using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using HtmlAgilityPack;
using System.Text.RegularExpressions;
using System.IO;

namespace ConsoleApplication1
{
    class Season
    {
        public int SeasonNo { get; protected set; }
        public IEnumerable<Episode> Episodes { get; protected set; }

        public override string ToString()
        {
            return string.Format("Season {0:00}\n{1}", SeasonNo, string.Join("\n", Episodes));
        }
    }

    class DirectorySeason : Season
    {
        public DirectorySeason(string directory)
        {
            SeasonNo = Convert.ToInt32(Regex.Match(Path.GetFileName(directory), @"\d+").Value);
            Episodes = (from episodeFile in System.IO.Directory.GetFiles(directory)
                       select new FileEpisode(episodeFile)).ToList();

            Directory = directory;
        }

        public string Directory { get; private set; }
    }

    class HtmlSeason : Season
    {
        public HtmlSeason(HtmlNode h3Node)
        {
            int seasonNo;
            Title = SeasonTitle(h3Node.InnerText, out seasonNo);
            SeasonNo = seasonNo;
            var tableNode = ClosestSibling(h3Node, "table");
            Episodes = (from trNode in tableNode.Elements("tr")
                       where trNode.Elements("td").Count() >= 2
                       select new HtmlEpisode(trNode)).ToList();
        }

        public string Title { get; private set; }

        public override string ToString()
        {
            return string.Format("{0}\n{1}", Title, string.Join("\n", Episodes));
        }

        static string SeasonTitle(string input, out int seasonNo)
        {
            Regex r = new Regex(@"Season (\d+) \((\d+)[^\d]+(\d+)");
            Match m = r.Match(input);
            if (m.Success)
            {
                seasonNo = Convert.ToInt32(m.Groups[1].Value);
                return string.Format("Season {0:00} ({1}-{2})", seasonNo, m.Groups[2].Value, m.Groups[3].Value);
            }
            else
            {
                throw new InvalidOperationException();
            }
        }

        static HtmlNode ClosestSibling(HtmlNode n, string name)
        {
            if (n == null)
            {
                return null;
            }

            HtmlNode p = n.NextSibling;
            while (p != null && !string.Equals(p.Name, name, StringComparison.InvariantCultureIgnoreCase))
            {
                p = p.NextSibling;
            }

            return p;
        }

    }

    class Episode
    {
        public int EpisodeNo { get; protected set; }

        public override string ToString()
        {
            return string.Format("Episode {0:00}", EpisodeNo);
        }
    }

    class FileEpisode : Episode
    {
        private static int? Match(string file, string pattern)
        {
            Match m = Regex.Match(file, pattern);
            if (m.Success)
            {
                return Convert.ToInt32(m.Groups[1].Value);
            }

            return null;
        }

        public FileEpisode(string file)
        {
            File = file;
            string filename = Path.GetFileName(file);
            EpisodeNo = Match(filename, @"E(\d+)")
                ?? Match(filename, @"fs?\d\d(\d+)")
                ?? Match(filename, @"Friends\.\dx(\d+)")
                ?? 0;

            if (EpisodeNo <= 0)
            {
                throw new InvalidOperationException("Invalid episode file " + file);
            }
        }

        public string File { get; private set; }

        public override string ToString()
        {
            return base.ToString() + " " + File;
        }
    }

    class HtmlEpisode : Episode
    {
        public HtmlEpisode(HtmlNode trNode)
        {
            var tds = trNode.Elements("td").ToArray();
            if (tds.Length >= 2)
            {
                TextEpisodeNo = ParseEpisodeNo(tds[0].InnerText).Replace('/', '-');
                Title = EpisodeTitle(tds[1].InnerText);
                EpisodeNo = Convert.ToInt32(Regex.Match(TextEpisodeNo, @"\d+").Value);
            }
            else
            {
                throw new InvalidOperationException();
            }
        }

        public string TextEpisodeNo { get; private set; }

        public string Title { get; private set; }

        public override string ToString()
        {
            return base.ToString() + " " + TextEpisodeNo + " " + Title;
        }

        static string EpisodeTitle(string input)
        {
            Regex r = new Regex(@"""(.+)""");
            MatchCollection matches = r.Matches(input);
            return string.Join(" - ", matches.OfType<Match>().Select(m => m.Groups[1].Value));
        }

        static string ParseEpisodeNo(string input)
        {
            int n;
            if (int.TryParse(input, out n))
            {
                return n.ToString("00");
            }
            else
            {
                return input;
            }
        }

    }

    class Program
    {
        static void Main(string[] args)
        {
            string p = @"\\Box\m1\TV Series\Friends";
            var directorySeasons = (from seasonDir in Directory.GetDirectories(p)
                          select new DirectorySeason(seasonDir)).ToList();

            foreach (var s in directorySeasons)
            {
                Console.WriteLine(s);
            }

            var htmlSeasons = WebRead().ToList();
            foreach (var s in htmlSeasons)
            {
                Console.WriteLine(s);
            }

            Assert(directorySeasons.Count == htmlSeasons.Count, "Different html and directory season counts");
            Assert(directorySeasons.All(ds => htmlSeasons.Any(hs => hs.SeasonNo == ds.SeasonNo)), "DirectorySeason not found");

            foreach (var directorySeason in directorySeasons)
            {
                var htmlSeason = htmlSeasons.Single(hs => hs.SeasonNo == directorySeason.SeasonNo);

                Console.WriteLine("Season {0:00}", directorySeason.SeasonNo);
                //Console.WriteLine("REN {0} {1}", directorySeason.Directory, Path.Combine(Path.GetDirectoryName(directorySeason.Directory), htmlSeason.Title));

                foreach (FileEpisode fileEpisode in directorySeason.Episodes)
                {
                    if (directorySeason.SeasonNo == 8 && fileEpisode.EpisodeNo == 24)
                    {
                        continue;
                    }

                    HtmlEpisode htmlEpisode = (HtmlEpisode)htmlSeason.Episodes.Single(he => he.EpisodeNo == fileEpisode.EpisodeNo);
                    Console.WriteLine(fileEpisode);
                    Console.WriteLine(htmlEpisode);

                    string newFile = Path.Combine(
                        Path.GetDirectoryName(fileEpisode.File),
                        htmlEpisode.TextEpisodeNo + " - " + htmlEpisode.Title + Path.GetExtension(fileEpisode.File));

                    Console.WriteLine(fileEpisode.File);
                    Console.WriteLine(newFile);

                    File.Move(fileEpisode.File, newFile);
                }
            }

            Console.ReadLine();
        }

        static void Assert(bool condition, string msg)
        {
            if (!condition)
            {
                throw new InvalidOperationException(msg);
            }
        }

        static IEnumerable<HtmlSeason> WebRead()
        {
            Uri uri = new Uri("http://en.wikipedia.org/wiki/List_of_Friends_episodes");
            var request = HttpWebRequest.Create(uri);
            var htmlDoc = new HtmlDocument();

            using (var response = request.GetResponse())
            {
                using (var stream = response.GetResponseStream())
                {
                    htmlDoc.Load(stream);
                }
            }

            HtmlNode content = htmlDoc.GetElementbyId("mw-content-text");
            return from h3Node in content.Elements("h3")
                   select new HtmlSeason(h3Node);
        }
    }
}
