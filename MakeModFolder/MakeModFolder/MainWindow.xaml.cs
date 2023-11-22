using System;
using System.Windows;
using System.IO;
using System.IO.Compression;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Xml;
using Microsoft.WindowsAPICodePack.Dialogs;

namespace MakeModFolder
{
	public partial class MainWindow : INotifyPropertyChanged
	{
		public MainWindow()
		{
			DataContext = this;
			InitializeComponent();
		}

		private string _modName;

		public string ModName
		{
			get => _modName;

			set
			{
				if (_modName != value)
				{
					_modName = value;
					OnPropertyChanged();
				}
			}
		}

		private string _repositoryPath;

		public string RepositoryPath
		{
			get => _repositoryPath;

			set
			{
				if (_repositoryPath != value)
				{
					_repositoryPath = value;
					OnPropertyChanged();
				}
			}
		}

		private void MakeModFolder()
		{
			var modPath = "../" + ModName;

			// Create the mod folder
			Directory.CreateDirectory(modPath);

			// Create the data folder
			Directory.CreateDirectory(modPath + "/data");

			// Copy the modding_eula.txt
			var files = Directory.GetFiles(RepositoryPath);
			foreach (var file in files)
			{
				if (file.Contains("modding_eula.txt"))
				{
					File.Copy(file, modPath + "/" + Path.GetFileName(file));
				}
			}

			//Create the mod.manifest file
			WriteModManifest();

			// Copy the data folder and zip it
			var dataPath = "";
			var directories = Directory.GetDirectories(RepositoryPath);
			foreach (var directory in directories)
			{
				if (directory.Contains("data"))
				{
					dataPath = directory;
					break;
				}
			}

			ZipFile.CreateFromDirectory(dataPath, modPath + "/data/data" + ".pak", CompressionLevel.Optimal, false);

			MessageBox.Show("Mod folder created successfully", "Success", MessageBoxButton.OK,
				MessageBoxImage.Information);
		}

		private void PathBrowse_Button_Click(object _sender, RoutedEventArgs _e)
		{
			CommonOpenFileDialog openFileDialog = new()
			{
				InitialDirectory = "c:\\",
				RestoreDirectory = true,
				IsFolderPicker = true
			};

			if (openFileDialog.ShowDialog() == CommonFileDialogResult.Ok)
			{
				// if in the folder there is a mod.manifest file and a modding_eula.txt file, then it's the right folder
				var files = Directory.GetFiles(openFileDialog.FileName);
				var isRepository = false;
				foreach (var file in files)
				{
					if (file.Contains("modding_eula.txt"))
					{
						isRepository = true;
						RepositoryPath = openFileDialog.FileName;
					}
				}

				if (!isRepository)
				{
					MessageBox.Show("The selected folder is not a valid repository", "Warning", MessageBoxButton.OK,
						MessageBoxImage.Warning);
				}
			}
		}

		private void Run_Button_Click(object _sender, RoutedEventArgs _e)
		{
			if (!string.IsNullOrEmpty(ModName) && !string.IsNullOrEmpty(RepositoryPath))
			{
				MakeModFolder();
			}
			else
			{
				MessageBox.Show("Please enter a mod name and select a repository path", "Warning", MessageBoxButton.OK,
					MessageBoxImage.Warning);
			}
		}

		private void WriteModManifest()
		{
			XmlWriterSettings settings = new()
			{
				Indent = true,
				IndentChars = "\t",
				NewLineOnAttributes = true
			};

			using XmlWriter writer = XmlWriter.Create("../" + ModName + "/mod.manifest", settings);

			writer.WriteStartDocument();
			writer.WriteStartElement("kcd_mod"); // kcd_mod
			writer.WriteStartElement("info"); // info
			writer.WriteStartElement("name"); // name
			writer.WriteValue(ModName);
			writer.WriteEndElement(); // /name
			writer.WriteStartElement("modid"); // modid
			writer.WriteValue(ModName);
			writer.WriteEndElement(); // /modid
			writer.WriteStartElement("description"); // description
			writer.WriteValue("A mod for Kingdom Come: Deliverance");
			writer.WriteEndElement(); // /description
			writer.WriteStartElement("author"); // author
			writer.WriteValue("Antstar609");
			writer.WriteEndElement(); // /author
			writer.WriteStartElement("version"); // version
			writer.WriteValue("1.0.0"); //TODO: make this a textbox
			writer.WriteEndElement(); // /version
			writer.WriteStartElement("created_on"); // created_on
			writer.WriteValue(DateTime.Now.ToString("dd.MM.yyyy"));
			writer.WriteEndElement(); // /created_on
			writer.WriteStartElement("modifies_level"); // modifies_level
			writer.WriteValue("false"); //TODO: make this a checkbox
			writer.WriteEndElement(); // /modifies_level
			writer.WriteEndElement(); // /info
			writer.WriteEndElement(); // /kcd_mod
			writer.WriteEndDocument();
		}

		public event PropertyChangedEventHandler? PropertyChanged;

		private void OnPropertyChanged([CallerMemberName] string? propertyName = null)
		{
			PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
		}
	}
}