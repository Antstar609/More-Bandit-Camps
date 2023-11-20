using System.Windows;
using System.IO;
using System.IO.Compression;
using System.ComponentModel;
using System.Runtime.CompilerServices;
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
			var modPath = "../" + _modName;

			// Create the mod folder
			Directory.CreateDirectory(modPath);

			// Create the data folder
			Directory.CreateDirectory(modPath + "/data");

			// Copy the mod.manifest and modding_eula.txt
			var files = Directory.GetFiles(_repositoryPath);
			foreach (var file in files)
			{
				if (file.Contains("mod.manifest") || file.Contains("modding_eula.txt"))
				{
					File.Copy(file, modPath + "/" + Path.GetFileName(file));
				}
			}

			// Copy the data folder and zip it
			var dataPath = "";
			var directories = Directory.GetDirectories(_repositoryPath);
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
				var modManifestFound = false;
				var moddingEulaFound = false;
				foreach (var file in files)
				{
					if (file.Contains("mod.manifest"))
						modManifestFound = true;
					if (file.Contains("modding_eula.txt"))
						moddingEulaFound = true;
				}

				if (moddingEulaFound && modManifestFound)
				{
					RepositoryPath = openFileDialog.FileName;
				}
				else
				{
					MessageBox.Show("The selected folder is not a valid repository", "Warning", MessageBoxButton.OK,
						MessageBoxImage.Warning);
				}
			}
		}

		private void Run_Button_Click(object _sender, RoutedEventArgs _e)
		{
			if (!string.IsNullOrEmpty(_modName) && !string.IsNullOrEmpty(_repositoryPath))
			{
				MakeModFolder();
			}
			else
			{
				MessageBox.Show("Please enter a mod name and select a repository path", "Warning", MessageBoxButton.OK,
					MessageBoxImage.Warning);
			}
		}

		public event PropertyChangedEventHandler? PropertyChanged;

		private void OnPropertyChanged([CallerMemberName] string? propertyName = null)
		{
			PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
		}
	}
}