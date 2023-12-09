using System;
using System.Collections.Generic;
using System.Windows;
using System.IO;
using System.IO.Compression;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Xml;
using Microsoft.WindowsAPICodePack.Dialogs;

// ReSharper disable UseVerbatimString

namespace MakeModFolder;

public partial class MainWindow : INotifyPropertyChanged
{
	public MainWindow()
	{
		DataContext = this;
		InitializeComponent();
		SetDefaultPath();
	}

	private List<(string, string, string)> defaultPathList = new()
	{
		//PC Name,		Game Path,		Repo Path
		("antoi",  "C:\\Games SSD\\steamapps\\common\\KingdomComeDeliverance", "D:\\Antoine\\Bazaar\\KCD Mod"),
		("Etudiant1", "C:\\Program Files (x86)\\Steam\\steamapps\\common\\KingdomComeDeliverance", "D:\\KCD_Mod")
	};
		
	private void SetDefaultPath()
	{
		var pcName = Environment.UserName;
		foreach (var value in defaultPathList)
		{
			if (value.Item1 == pcName)
			{
				GamePath = value.Item2;
				RepoPath = value.Item3;
				break;
			}

			GamePath = "";
			RepoPath = "";
		}
	}

	private void MakeModFolder()
	{
		var modPath = GamePath + "\\mods\\" + ModName;
			
		// Check if the mod folder already exists, if it exists, delete it
		if (Directory.Exists(modPath))
		{
			Directory.Delete(modPath, true);
		}

		// Create the mod folder
		Directory.CreateDirectory(modPath);

		// Create the main folders
		Directory.CreateDirectory(modPath + "\\data");
		Directory.CreateDirectory(modPath + "\\localization");

		// Copy the modding_eula.txt
		var files = Directory.GetFiles(Directory.GetCurrentDirectory());
		foreach (var file in files)
		{
			if (file.Contains("modding_eula.txt"))
			{
				File.Copy(file, modPath + "\\" + Path.GetFileName(file));
				break;
			}
		}

		//Create the mod.manifest file
		WriteModManifest();

		// Copy the data folder and zip it
		var dataPath = "";
		var localizationPath = "";
		var directories = Directory.GetDirectories(RepoPath);
		var isDatazipped = false;
		var isLocalizationzipped = false;
		foreach (var directory in directories)
		{
			if (directory.Contains("data") && !isDatazipped)
			{
				dataPath = directory;
				isDatazipped = true;
			}

			if (directory.Contains("localization") && !isLocalizationzipped)
			{
				localizationPath = directory;
				isLocalizationzipped = true;
			}

			if (isDatazipped && isLocalizationzipped)
				break;
		}

		ZipFile.CreateFromDirectory(dataPath, modPath + "\\data\\data" + ".pak", CompressionLevel.Optimal, false);
		ZipFile.CreateFromDirectory(localizationPath, modPath + "\\localization\\English_xml" + ".pak",
			CompressionLevel.Optimal, false);

		// MessageBox the user that the mod folder has been created and the location of it
		MessageBox.Show("The mod folder has been created at " + modPath, "Success", MessageBoxButton.OK,
			MessageBoxImage.Information);
		Application.Current.Shutdown();
	}

	private void WriteModManifest()
	{
		XmlWriterSettings settings = new()
		{
			Indent = true,
			IndentChars = "\t",
			NewLineOnAttributes = true
		};

		using XmlWriter writer = XmlWriter.Create(GamePath + "\\mods\\" + ModName + "\\mod.manifest", settings);

		writer.WriteStartDocument();
		writer.WriteStartElement("kcd_mod"); // kcd_mod
		writer.WriteStartElement("info"); // info
		writer.WriteStartElement("name"); // name
		writer.WriteValue(ModName);
		writer.WriteEndElement(); // /name
		writer.WriteStartElement("modid"); // modid
		writer.WriteValue(ModName.ToLower());
		writer.WriteEndElement(); // /modid
		writer.WriteStartElement("description"); // description
		writer.WriteValue("A mod for Kingdom Come: Deliverance");
		writer.WriteEndElement(); // /description
		writer.WriteStartElement("author"); // author
		writer.WriteValue("Antstar609");
		writer.WriteEndElement(); // /author
		writer.WriteStartElement("version"); // version
		writer.WriteValue(ModVersion);
		writer.WriteEndElement(); // /version
		writer.WriteStartElement("created_on"); // created_on
		writer.WriteValue(DateTime.Now.ToString("dd.MM.yyyy"));
		writer.WriteEndElement(); // /created_on
		writer.WriteStartElement("modifies_level"); // modifies_level
		writer.WriteValue(IsMapModified);
		writer.WriteEndElement(); // /modifies_level
		writer.WriteEndElement(); // /info
		writer.WriteEndElement(); // /kcd_mod
		writer.WriteEndDocument();
	}

	private void RepoBrowsePath_Button_Click(object _sender, RoutedEventArgs _e)
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
			if (files.Any(file => file.Contains("ModRepository.txt")))
			{
				isRepository = true;
				RepoPath = openFileDialog.FileName;
			}

			if (!isRepository)
			{
				MessageBox.Show("The selected folder is not a valid repository", "Warning", MessageBoxButton.OK,
					MessageBoxImage.Warning);
			}
		}
	}

	private void GameBrowsePath_Button_Click(object _sender, RoutedEventArgs _e)
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
			var isGame = false;
			if (files.Any(file => file.Contains("kcd.log")))
			{
				isGame = true;
				GamePath = openFileDialog.FileName;
			}

			if (!isGame)
			{
				MessageBox.Show("The selected folder is not a valid game folder", "Warning", MessageBoxButton.OK,
					MessageBoxImage.Warning);
			}
		}
	}

	private void Run_Button_Click(object _sender, RoutedEventArgs _e)
	{
		if (!string.IsNullOrEmpty(ModName) && !string.IsNullOrEmpty(RepoPath) &&
		    !string.IsNullOrEmpty(GamePath) && !string.IsNullOrEmpty(ModVersion))
		{
			MakeModFolder();
		}
		else
		{
			MessageBox.Show("Please fill all the fields", "Warning", MessageBoxButton.OK,
				MessageBoxImage.Warning);
		}
	}

	private string _modName = "TestMod";

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

	private string _repoPath = "";
		
	public string RepoPath
	{
		get => _repoPath;

		set
		{
			if (_repoPath != value)
			{
				_repoPath = value;
				OnPropertyChanged();
			}
		}
	}

	private string _gamePath = "";

	public string GamePath
	{
		get => _gamePath;

		set
		{
			if (_gamePath != value)
			{
				_gamePath = value;
				OnPropertyChanged();
			}
		}
	}

	private string _modVersion = "0.1";

	public string ModVersion
	{
		get => _modVersion;
		set
		{
			if (_modVersion != value)
			{
				_modVersion = value;
				OnPropertyChanged();
			}
		}
	}

	private string _isMapModified = "False";

	public string IsMapModified
	{
		get => _isMapModified;

		set
		{
			if (_isMapModified != value)
			{
				_isMapModified = value;
				OnPropertyChanged();
			}
		}
	}

	public event PropertyChangedEventHandler? PropertyChanged;

	private void OnPropertyChanged([CallerMemberName] string? propertyName = null)
	{
		PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
	}
}