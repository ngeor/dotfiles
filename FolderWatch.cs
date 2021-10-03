using System;
using System.Reflection;
using System.IO;
using System.Diagnostics;
using Mono.Options;

namespace FolderWatch
{
	public class Program
	{
		private static string command = null;

		public static void Main(string[] args)
		{
			string directory = null;

			var p = new OptionSet
			{
				{ "d|directory=", "the directory to watch", d => directory = d },
				{ "c|command=", "the command to run", c => command = c }
			};

			try
			{
				p.Parse(args);
			}
			catch (OptionException)
			{
				ShowHelp(p, Console.Error);
				Environment.Exit(1);
			}

			if (directory == null || command == null)
			{
				ShowHelp(p, Console.Error);
				Environment.Exit(1);
			}

			try
			{
				Run(directory, command);
			}
			catch (Exception ex)
			{
				Console.Error.WriteLine(ex);
				Environment.Exit(1);
			}
		}

		private static void Run(string directory, string command)
		{
			FileSystemWatcher fsw;
			fsw = new FileSystemWatcher
			{
				Path = directory,
				IncludeSubdirectories = true
			};

			fsw.Created += OnFileEvent;
			fsw.Deleted += OnFileEvent;
			fsw.Changed += OnFileEvent;

			fsw.EnableRaisingEvents = true;
			Console.Write("Monitoring folder, press enter to exit ");
			Console.ReadLine();
		}

		private static void ShowHelp(OptionSet p, TextWriter output)
		{
			output.WriteLine("Usage: folderwatch [OPTIONS]");
			p.WriteOptionDescriptions(output);
		}

		/// <summary>
		/// Handles file events.
		/// </summary>
		private static void OnFileEvent(object sender, FileSystemEventArgs e)
		{
			Console.WriteLine("ChangeType {0} FullPath {1} Name {2}", e.ChangeType, e.FullPath, e.Name);
			Process.Start(command);
		}
	}
}
