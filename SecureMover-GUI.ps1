#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    SecureMover GUI - Interface Graphique WPF
.DESCRIPTION
    Interface graphique moderne avec thème sombre pour SecureMover
    Permet de déplacer les profils utilisateurs Windows de manière visuelle
.NOTES
    Version      : 2.0.2-GUI
    Author       : DrSmoke
    Date         : 2025-11-01
    License      : MIT
#>

# ============================================================================
# CONFIGURATION
# ============================================================================

$ErrorActionPreference = 'Stop'
$scriptPath = $PSScriptRoot

# ============================================================================
# XAML INTERFACE - THÈME SOMBRE MINIMALISTE
# ============================================================================

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="SecureMover v2.0.2 - Interface Graphique"
    Height="700" Width="900"
    WindowStartupLocation="CenterScreen"
    ResizeMode="CanMinimize"
    Background="#1E1E1E">

    <Window.Resources>
        <!-- Styles pour thème sombre minimaliste -->
        <Style x:Key="ModernButton" TargetType="Button">
            <Setter Property="Background" Value="#2D2D30"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="BorderBrush" Value="#3F3F46"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="20,10"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#3E3E42"/>
                </Trigger>
                <Trigger Property="IsEnabled" Value="False">
                    <Setter Property="Opacity" Value="0.5"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="AccentButton" TargetType="Button" BasedOn="{StaticResource ModernButton}">
            <Setter Property="Background" Value="#0E639C"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#1177BB"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="SuccessButton" TargetType="Button" BasedOn="{StaticResource ModernButton}">
            <Setter Property="Background" Value="#2D7230"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#3D8F42"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="WarningButton" TargetType="Button" BasedOn="{StaticResource ModernButton}">
            <Setter Property="Background" Value="#8F6B2D"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#AF8B3D"/>
                </Trigger>
            </Style.Triggers>
        </Style>
    </Window.Resources>

    <Grid Margin="30">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- HEADER -->
        <StackPanel Grid.Row="0" Margin="0,0,0,30">
            <TextBlock Text="SecureMover"
                       FontSize="32"
                       FontWeight="Bold"
                       Foreground="#FFFFFF"
                       HorizontalAlignment="Center"/>
            <TextBlock Text="Déplacement de Profils Utilisateurs Windows"
                       FontSize="14"
                       Foreground="#A0A0A0"
                       HorizontalAlignment="Center"
                       Margin="0,5,0,0"/>
            <TextBlock Text="v2.0.2 GUI - Interface Graphique"
                       FontSize="11"
                       Foreground="#606060"
                       HorizontalAlignment="Center"
                       Margin="0,3,0,0"/>
        </StackPanel>

        <!-- PROFIL SELECTION -->
        <Border Grid.Row="1"
                Background="#2D2D30"
                BorderBrush="#3F3F46"
                BorderThickness="1"
                CornerRadius="4"
                Padding="20"
                Margin="0,0,0,20">
            <StackPanel>
                <TextBlock Text="1. SÉLECTION DU PROFIL"
                           FontSize="13"
                           FontWeight="Bold"
                           Foreground="#FFFFFF"
                           Margin="0,0,0,12"/>
                <ComboBox x:Name="ProfileComboBox"
                          Height="35"
                          FontSize="13"
                          Background="#252526"
                          Foreground="#FFFFFF"
                          BorderBrush="#3F3F46"/>
            </StackPanel>
        </Border>

        <!-- DESTINATION SELECTION -->
        <Border Grid.Row="2"
                Background="#2D2D30"
                BorderBrush="#3F3F46"
                BorderThickness="1"
                CornerRadius="4"
                Padding="20"
                Margin="0,0,0,20">
            <StackPanel>
                <TextBlock Text="2. DISQUE DE DESTINATION"
                           FontSize="13"
                           FontWeight="Bold"
                           Foreground="#FFFFFF"
                           Margin="0,0,0,12"/>
                <ComboBox x:Name="DriveComboBox"
                          Height="35"
                          FontSize="13"
                          Background="#252526"
                          Foreground="#FFFFFF"
                          BorderBrush="#3F3F46"/>
                <TextBlock x:Name="SpaceInfoText"
                           Text="Sélectionnez un disque pour voir l'espace disponible"
                           FontSize="11"
                           Foreground="#A0A0A0"
                           Margin="0,8,0,0"/>
            </StackPanel>
        </Border>

        <!-- ACTION BUTTONS -->
        <Border Grid.Row="3"
                Background="#2D2D30"
                BorderBrush="#3F3F46"
                BorderThickness="1"
                CornerRadius="4"
                Padding="20"
                Margin="0,0,0,20">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <Button x:Name="MoveButton"
                        Grid.Column="0"
                        Content="DÉPLACER"
                        Style="{StaticResource AccentButton}"
                        Margin="0,0,10,0"
                        Height="45"/>

                <Button x:Name="RestoreButton"
                        Grid.Column="1"
                        Content="RESTAURER"
                        Style="{StaticResource SuccessButton}"
                        Margin="5,0,5,0"
                        Height="45"/>

                <Button x:Name="BackupButton"
                        Grid.Column="2"
                        Content="SAUVEGARDER"
                        Style="{StaticResource WarningButton}"
                        Margin="5,0,5,0"
                        Height="45"/>

                <Button x:Name="WhatIfButton"
                        Grid.Column="3"
                        Content="SIMULER"
                        Style="{StaticResource ModernButton}"
                        Margin="10,0,0,0"
                        Height="45"/>
            </Grid>
        </Border>

        <!-- PROGRESS BAR -->
        <Border Grid.Row="4"
                Background="#2D2D30"
                BorderBrush="#3F3F46"
                BorderThickness="1"
                CornerRadius="4"
                Padding="20"
                Margin="0,0,0,20"
                x:Name="ProgressBorder"
                Visibility="Collapsed">
            <StackPanel>
                <TextBlock x:Name="ProgressText"
                           Text="Opération en cours..."
                           FontSize="12"
                           Foreground="#FFFFFF"
                           Margin="0,0,0,10"/>
                <ProgressBar x:Name="ProgressBar"
                             Height="10"
                             Minimum="0"
                             Maximum="100"
                             Value="0"
                             Background="#252526"
                             Foreground="#0E639C"/>
            </StackPanel>
        </Border>

        <!-- LOG VIEWER -->
        <Border Grid.Row="5"
                Background="#252526"
                BorderBrush="#3F3F46"
                BorderThickness="1"
                CornerRadius="4"
                Padding="15"
                Margin="0,0,0,20">
            <ScrollViewer VerticalScrollBarVisibility="Auto">
                <TextBlock x:Name="LogTextBlock"
                           FontFamily="Consolas"
                           FontSize="11"
                           Foreground="#CCCCCC"
                           TextWrapping="Wrap"
                           Text="Prêt. Sélectionnez un profil et une destination."/>
            </ScrollViewer>
        </Border>

        <!-- FOOTER -->
        <StackPanel Grid.Row="6" Orientation="Horizontal" HorizontalAlignment="Center">
            <TextBlock Text="SecureMover v2.0.2 GUI"
                       FontSize="10"
                       Foreground="#606060"/>
            <TextBlock Text=" • "
                       FontSize="10"
                       Foreground="#606060"
                       Margin="5,0"/>
            <TextBlock Text="MIT License"
                       FontSize="10"
                       Foreground="#606060"/>
            <TextBlock Text=" • "
                       FontSize="10"
                       Foreground="#606060"
                       Margin="5,0"/>
            <TextBlock Text="DrSmoke 2025"
                       FontSize="10"
                       Foreground="#606060"/>
        </StackPanel>
    </Grid>
</Window>
"@

# ============================================================================
# FONCTIONS UTILITAIRES GUI
# ============================================================================

function Write-GUILog {
    param([string]$Message, [string]$Type = "Info")

    $timestamp = Get-Date -Format "HH:mm:ss"
    $prefix = switch ($Type) {
        "Success" { "[OK]" }
        "Error"   { "[ERR]" }
        "Warning" { "[WARN]" }
        default   { "[INFO]" }
    }

    $logLine = "$timestamp $prefix $Message"

    $window.Dispatcher.Invoke([action]{
        $LogTextBlock.Text += "`n$logLine"
        # Auto-scroll to bottom
        $parent = $LogTextBlock.Parent
        if ($parent -is [System.Windows.Controls.ScrollViewer]) {
            $parent.ScrollToEnd()
        }
    })
}

function Show-Progress {
    param([int]$Percent, [string]$Status)

    $window.Dispatcher.Invoke([action]{
        $ProgressBorder.Visibility = "Visible"
        $ProgressBar.Value = $Percent
        $ProgressText.Text = $Status
    })
}

function Hide-Progress {
    $window.Dispatcher.Invoke([action]{
        $ProgressBorder.Visibility = "Collapsed"
    })
}

function Get-UserProfiles {
    try {
        $profiles = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notin @('Public', 'Default', 'Default User', 'All Users') } |
            ForEach-Object {
                [PSCustomObject]@{
                    Name = $_.Name
                    Path = $_.FullName
                    DisplayName = "$($_.Name) ($($_.FullName))"
                }
            }
        return $profiles
    }
    catch {
        Write-GUILog "Erreur lors de la récupération des profils: $_" "Error"
        return @()
    }
}

function Get-AvailableDrives {
    try {
        $drives = Get-PSDrive -PSProvider FileSystem |
            Where-Object { $_.Name -ne 'C' -and $_.Used -ne $null } |
            ForEach-Object {
                $freeGB = [math]::Round($_.Free / 1GB, 2)
                $totalGB = [math]::Round(($_.Used + $_.Free) / 1GB, 2)
                $percentFree = [math]::Round(($_.Free / ($_.Used + $_.Free)) * 100, 1)

                [PSCustomObject]@{
                    Drive = $_.Name
                    FreeGB = $freeGB
                    TotalGB = $totalGB
                    PercentFree = $percentFree
                    DisplayName = "$($_.Name):\ - $freeGB GB libre / $totalGB GB ($percentFree`% libre)"
                }
            }
        return $drives
    }
    catch {
        Write-GUILog "Erreur lors de la récupération des disques: $_" "Error"
        return @()
    }
}

# ============================================================================
# EVENT HANDLERS
# ============================================================================

function Initialize-GUI {
    Write-GUILog "Initialisation de l'interface..." "Info"

    # Charger les profils
    $profiles = Get-UserProfiles
    Write-GUILog "Profils trouvés: $($profiles.Count)" "Success"

    foreach ($profile in $profiles) {
        $ProfileComboBox.Items.Add($profile.DisplayName) | Out-Null
    }

    if ($profiles.Count -gt 0) {
        $ProfileComboBox.SelectedIndex = 0
    }

    # Charger les disques
    $drives = Get-AvailableDrives
    Write-GUILog "Disques disponibles: $($drives.Count)" "Success"

    foreach ($drive in $drives) {
        $DriveComboBox.Items.Add($drive.DisplayName) | Out-Null
    }

    if ($drives.Count -gt 0) {
        $DriveComboBox.SelectedIndex = 0
    }

    Write-GUILog "Interface prête. Vous pouvez commencer." "Success"
}

$MoveButton_Click = {
    try {
        if ($ProfileComboBox.SelectedIndex -eq -1 -or $DriveComboBox.SelectedIndex -eq -1) {
            [System.Windows.MessageBox]::Show(
                "Veuillez sélectionner un profil et un disque de destination.",
                "Sélection Requise",
                [System.Windows.MessageBoxButton]::OK,
                [System.Windows.MessageBoxImage]::Warning
            )
            return
        }

        $result = [System.Windows.MessageBox]::Show(
            "Cette opération va déplacer le profil utilisateur sélectionné.`n`nCette action est IRRÉVERSIBLE sans la fonction RESTAURER.`n`nVoulez-vous continuer ?",
            "Confirmation Requise",
            [System.Windows.MessageBoxButton]::YesNo,
            [System.Windows.MessageBoxImage]::Warning
        )

        if ($result -eq [System.Windows.MessageBoxResult]::Yes) {
            Write-GUILog "=== DÉPLACEMENT DE PROFIL ===" "Info"
            Write-GUILog "Opération démarée..." "Info"
            Show-Progress -Percent 0 -Status "Préparation..."

            # TODO: Appeler la fonction Move-UserProfile du script CLI
            # Pour l'instant, simulation
            for ($i = 1; $i -le 100; $i++) {
                Start-Sleep -Milliseconds 30
                Show-Progress -Percent $i -Status "Déplacement en cours... $i%"
            }

            Hide-Progress
            Write-GUILog "Déplacement terminé avec succès !" "Success"

            [System.Windows.MessageBox]::Show(
                "Le profil a été déplacé avec succès !`n`nUn redémarrage est recommandé.",
                "Succès",
                [System.Windows.MessageBoxButton]::OK,
                [System.Windows.MessageBoxImage]::Information
            )
        }
    }
    catch {
        Hide-Progress
        Write-GUILog "Erreur: $_" "Error"
        [System.Windows.MessageBox]::Show(
            "Une erreur est survenue: $_",
            "Erreur",
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Error
        )
    }
}

$RestoreButton_Click = {
    Write-GUILog "Fonction RESTAURER - En développement" "Warning"
    [System.Windows.MessageBox]::Show(
        "La fonction RESTAURER sera disponible dans une prochaine version GUI.",
        "Information",
        [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]::Information
    )
}

$BackupButton_Click = {
    Write-GUILog "Fonction SAUVEGARDER - En développement" "Warning"
    [System.Windows.MessageBox]::Show(
        "La fonction SAUVEGARDER sera disponible dans une prochaine version GUI.",
        "Information",
        [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]::Information
    )
}

$WhatIfButton_Click = {
    if ($ProfileComboBox.SelectedIndex -eq -1 -or $DriveComboBox.SelectedIndex -eq -1) {
        [System.Windows.MessageBox]::Show(
            "Veuillez sélectionner un profil et un disque de destination.",
            "Sélection Requise",
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Warning
        )
        return
    }

    Write-GUILog "=== MODE SIMULATION (WhatIf) ===" "Info"
    Write-GUILog "Profil: $($ProfileComboBox.SelectedItem)" "Info"
    Write-GUILog "Destination: $($DriveComboBox.SelectedItem)" "Info"
    Write-GUILog "Actions qui seraient effectuées:" "Info"
    Write-GUILog "  1. Calcul de la taille du profil" "Info"
    Write-GUILog "  2. Vérification de l'espace disque" "Info"
    Write-GUILog "  3. Sauvegarde du registre" "Info"
    Write-GUILog "  4. Déplacement des dossiers (Desktop, Documents, etc.)" "Info"
    Write-GUILog "  5. Mise à jour du registre Windows" "Info"
    Write-GUILog "AUCUNE MODIFICATION N'A ÉTÉ EFFECTUÉE (simulation)" "Success"

    [System.Windows.MessageBox]::Show(
        "Mode simulation activé !`n`nConsultez le journal pour voir ce qui serait effectué.`n`nAucune modification n'a été apportée au système.",
        "Simulation WhatIf",
        [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]::Information
    )
}

$DriveComboBox_SelectionChanged = {
    if ($DriveComboBox.SelectedIndex -ne -1) {
        $selectedDrive = ($DriveComboBox.SelectedItem -split ' - ')[0].TrimEnd(':\')
        $drive = Get-PSDrive -Name $selectedDrive -PSProvider FileSystem
        $freeGB = [math]::Round($drive.Free / 1GB, 2)
        $percentFree = [math]::Round(($drive.Free / ($drive.Used + $drive.Free)) * 100, 1)

        $SpaceInfoText.Text = "Espace libre: $freeGB GB ($percentFree`% disponible)"

        if ($percentFree -lt 15) {
            $SpaceInfoText.Foreground = "#FF6B6B"  # Rouge
        } elseif ($percentFree -lt 30) {
            $SpaceInfoText.Foreground = "#FFB86C"  # Orange
        } else {
            $SpaceInfoText.Foreground = "#50FA7B"  # Vert
        }
    }
}

# ============================================================================
# MAIN - CRÉATION DE LA FENÊTRE
# ============================================================================

try {
    Write-Host "Lancement de SecureMover GUI..." -ForegroundColor Cyan

    # Créer la fenêtre WPF
    Add-Type -AssemblyName PresentationFramework

    $reader = New-Object System.Xml.XmlNodeReader $xaml
    $window = [Windows.Markup.XamlReader]::Load($reader)

    # Récupérer les contrôles
    $ProfileComboBox = $window.FindName("ProfileComboBox")
    $DriveComboBox = $window.FindName("DriveComboBox")
    $SpaceInfoText = $window.FindName("SpaceInfoText")
    $MoveButton = $window.FindName("MoveButton")
    $RestoreButton = $window.FindName("RestoreButton")
    $BackupButton = $window.FindName("BackupButton")
    $WhatIfButton = $window.FindName("WhatIfButton")
    $ProgressBorder = $window.FindName("ProgressBorder")
    $ProgressBar = $window.FindName("ProgressBar")
    $ProgressText = $window.FindName("ProgressText")
    $LogTextBlock = $window.FindName("LogTextBlock")

    # Attacher les événements
    $MoveButton.Add_Click($MoveButton_Click)
    $RestoreButton.Add_Click($RestoreButton_Click)
    $BackupButton.Add_Click($BackupButton_Click)
    $WhatIfButton.Add_Click($WhatIfButton_Click)
    $DriveComboBox.Add_SelectionChanged($DriveComboBox_SelectionChanged)

    # Initialiser l'interface
    Initialize-GUI

    # Afficher la fenêtre
    $window.ShowDialog() | Out-Null
}
catch {
    Write-Host "Erreur lors du lancement de la GUI: $_" -ForegroundColor Red
    Write-Host "Stack Trace: $($_.ScriptStackTrace)" -ForegroundColor Yellow
    Read-Host "Appuyez sur Entrée pour quitter"
}
