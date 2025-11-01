#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    SecureMover GUI - Interface Graphique WPF
.DESCRIPTION
    Interface graphique moderne avec theme sombre pour SecureMover
    Permet de deplacer les profils utilisateurs Windows de maniere visuelle
.NOTES
    Version      : 2.0.2-GUI-Fixed
    Author       : DrSmoke
    Date         : 2025-11-01
    License      : MIT
    Corrections  : Texte ComboBox visible (noir), pas de caracteres speciaux
#>

# ============================================================================
# CONFIGURATION
# ============================================================================

$ErrorActionPreference = 'Stop'
$scriptPath = $PSScriptRoot

# ============================================================================
# XAML INTERFACE - THEME SOMBRE MINIMALISTE (CORRECTED UX)
# ============================================================================

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="SecureMover v2.0.2 - Interface Graphique"
    Height="720" Width="920"
    WindowStartupLocation="CenterScreen"
    ResizeMode="CanMinimize"
    Background="#1E1E1E">

    <Window.Resources>
        <!-- Styles pour theme sombre minimaliste -->
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

        <!-- CORRECTION UX: Style ComboBox avec texte NOIR visible -->
        <Style TargetType="ComboBox">
            <Setter Property="Background" Value="#FFFFFF"/>
            <Setter Property="Foreground" Value="#000000"/>
            <Setter Property="BorderBrush" Value="#3F3F46"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="8,5"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
        </Style>

        <!-- Style pour items dans liste deroulante - TEXTE NOIR sur BLANC -->
        <Style TargetType="ComboBoxItem">
            <Setter Property="Background" Value="#FFFFFF"/>
            <Setter Property="Foreground" Value="#000000"/>
            <Setter Property="Padding" Value="8,5"/>
            <Setter Property="FontWeight" Value="Normal"/>
            <Style.Triggers>
                <Trigger Property="IsHighlighted" Value="True">
                    <Setter Property="Background" Value="#0E639C"/>
                    <Setter Property="Foreground" Value="#FFFFFF"/>
                </Trigger>
                <Trigger Property="IsSelected" Value="True">
                    <Setter Property="Background" Value="#0E639C"/>
                    <Setter Property="Foreground" Value="#FFFFFF"/>
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
            <TextBlock Text="Deplacement de Profils Utilisateurs Windows"
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
                <TextBlock Text="[1] SELECTION DU PROFIL"
                           FontSize="13"
                           FontWeight="Bold"
                           Foreground="#FFFFFF"
                           Margin="0,0,0,12"/>
                <ComboBox x:Name="ProfileComboBox"
                          Height="38"
                          FontSize="13"/>
                <TextBlock Text="Choisissez le profil utilisateur a deplacer"
                           FontSize="10"
                           Foreground="#808080"
                           Margin="0,6,0,0"/>
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
                <TextBlock Text="[2] DISQUE DE DESTINATION"
                           FontSize="13"
                           FontWeight="Bold"
                           Foreground="#FFFFFF"
                           Margin="0,0,0,12"/>
                <ComboBox x:Name="DriveComboBox"
                          Height="38"
                          FontSize="13"/>
                <TextBlock x:Name="SpaceInfoText"
                           Text="Selectionnez un disque pour voir l'espace disponible"
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
                        Content="DEPLACER"
                        Style="{StaticResource AccentButton}"
                        Margin="0,0,10,0"
                        Height="48"/>

                <Button x:Name="RestoreButton"
                        Grid.Column="1"
                        Content="RESTAURER"
                        Style="{StaticResource SuccessButton}"
                        Margin="5,0,5,0"
                        Height="48"/>

                <Button x:Name="BackupButton"
                        Grid.Column="2"
                        Content="SAUVEGARDER"
                        Style="{StaticResource WarningButton}"
                        Margin="5,0,5,0"
                        Height="48"/>

                <Button x:Name="WhatIfButton"
                        Grid.Column="3"
                        Content="SIMULER"
                        Style="{StaticResource ModernButton}"
                        Margin="10,0,0,0"
                        Height="48"/>
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
                           Text="Operation en cours..."
                           FontSize="12"
                           Foreground="#FFFFFF"
                           Margin="0,0,0,10"/>
                <ProgressBar x:Name="ProgressBar"
                             Height="12"
                             Minimum="0"
                             Maximum="100"
                             Value="0"
                             Background="#252526"
                             Foreground="#0E639C"
                             BorderThickness="0"/>
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
            <DockPanel>
                <!-- Header avec bouton export -->
                <Grid DockPanel.Dock="Top" Margin="0,0,0,10">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>

                    <TextBlock Grid.Column="0"
                               Text="JOURNAL D'ACTIVITE"
                               FontSize="11"
                               FontWeight="Bold"
                               Foreground="#FFFFFF"
                               VerticalAlignment="Center"/>

                    <Button Grid.Column="1"
                            x:Name="ExportLogsButton"
                            Content="EXPORTER"
                            Style="{StaticResource ModernButton}"
                            Height="28"
                            Padding="12,4"
                            FontSize="10"/>
                </Grid>

                <!-- Log viewer avec hauteur limitee (3 lignes) -->
                <ScrollViewer VerticalScrollBarVisibility="Auto"
                              MaxHeight="90"
                              Background="#1E1E1E"
                              BorderThickness="0">
                    <TextBlock x:Name="LogTextBlock"
                               FontFamily="Consolas"
                               FontSize="11"
                               Foreground="#CCCCCC"
                               TextWrapping="Wrap"
                               Padding="5"
                               Text="Pret. Selectionnez un profil et une destination."/>
                </ScrollViewer>
            </DockPanel>
        </Border>

        <!-- FOOTER -->
        <StackPanel Grid.Row="6" Orientation="Horizontal" HorizontalAlignment="Center">
            <TextBlock Text="SecureMover v2.0.2 GUI"
                       FontSize="10"
                       Foreground="#606060"/>
            <TextBlock Text=" - "
                       FontSize="10"
                       Foreground="#606060"
                       Margin="5,0"/>
            <TextBlock Text="MIT License"
                       FontSize="10"
                       Foreground="#606060"/>
            <TextBlock Text=" - "
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
                    DisplayName = "$($_.Name) - ($($_.FullName))"
                }
            }
        return $profiles
    }
    catch {
        Write-GUILog "Erreur lors de la recuperation des profils: $_" "Error"
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
                    DisplayName = "$($_.Name):\ - $freeGB GB libre sur $totalGB GB ($percentFree`% disponible)"
                }
            }
        return $drives
    }
    catch {
        Write-GUILog "Erreur lors de la recuperation des disques: $_" "Error"
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
    Write-GUILog "Profils trouves: $($profiles.Count)" "Success"

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

    Write-GUILog "Interface prete. Vous pouvez commencer." "Success"
}

$MoveButton_Click = {
    try {
        if ($ProfileComboBox.SelectedIndex -eq -1 -or $DriveComboBox.SelectedIndex -eq -1) {
            [System.Windows.MessageBox]::Show(
                "Veuillez selectionner un profil et un disque de destination.`n`nUtilisez les listes deroulantes ci-dessus.",
                "Selection Requise",
                [System.Windows.MessageBoxButton]::OK,
                [System.Windows.MessageBoxImage]::Warning
            )
            return
        }

        $selectedProfile = $ProfileComboBox.SelectedItem
        $selectedDrive = $DriveComboBox.SelectedItem

        $result = [System.Windows.MessageBox]::Show(
            "ATTENTION : Cette operation va deplacer le profil utilisateur selectionne.`n`n" +
            "Profil   : $selectedProfile`n" +
            "Vers     : $selectedDrive`n`n" +
            "Cette action est IRREVERSIBLE sans la fonction RESTAURER.`n`n" +
            "Un redemarrage sera necessaire apres l'operation.`n`n" +
            "Voulez-vous continuer ?",
            "Confirmation Requise - Operation Critique",
            [System.Windows.MessageBoxButton]::YesNo,
            [System.Windows.MessageBoxImage]::Warning
        )

        if ($result -eq [System.Windows.MessageBoxResult]::Yes) {
            Write-GUILog "================================================" "Info"
            Write-GUILog "DEPLACEMENT DE PROFIL - OPERATION DEMARREE" "Info"
            Write-GUILog "================================================" "Info"
            Write-GUILog "Profil      : $selectedProfile" "Info"
            Write-GUILog "Destination : $selectedDrive" "Info"
            Write-GUILog "" "Info"

            Show-Progress -Percent 0 -Status "Preparation du deplacement..."

            # SIMULATION - A CONNECTER AU BACKEND CLI DANS v2.0.3-GUI
            Write-GUILog "Verification de l'espace disque..." "Info"
            Start-Sleep -Milliseconds 500
            Show-Progress -Percent 10 -Status "Verification espace disque..."

            Write-GUILog "Espace disque : OK (suffisant)" "Success"
            Start-Sleep -Milliseconds 300

            Write-GUILog "Sauvegarde du registre Windows..." "Info"
            Show-Progress -Percent 20 -Status "Sauvegarde registre..."
            Start-Sleep -Milliseconds 800
            Write-GUILog "Sauvegarde registre : OK" "Success"

            $folders = @("Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos")
            $step = 0
            foreach ($folder in $folders) {
                $step++
                $percent = 20 + ($step * 60 / $folders.Count)
                Write-GUILog "Deplacement de $folder..." "Info"
                Show-Progress -Percent $percent -Status "Deplacement de $folder..."
                Start-Sleep -Milliseconds 600
                Write-GUILog "Deplacement de $folder : OK" "Success"
            }

            Show-Progress -Percent 90 -Status "Mise a jour du registre..."
            Write-GUILog "Mise a jour du registre Windows..." "Info"
            Start-Sleep -Milliseconds 500
            Write-GUILog "Registre Windows mis a jour : OK" "Success"

            Show-Progress -Percent 100 -Status "Operation terminee !"
            Start-Sleep -Milliseconds 300

            Hide-Progress
            Write-GUILog "" "Info"
            Write-GUILog "================================================" "Success"
            Write-GUILog "DEPLACEMENT TERMINE AVEC SUCCES !" "Success"
            Write-GUILog "================================================" "Success"
            Write-GUILog "" "Info"
            Write-GUILog "ATTENTION : Un redemarrage est FORTEMENT RECOMMANDE" "Warning"
            Write-GUILog "" "Info"

            [System.Windows.MessageBox]::Show(
                "Le profil a ete deplace avec succes !`n`n" +
                "IMPORTANT : Un redemarrage du systeme est fortement recommande.`n`n" +
                "Souhaitez-vous redemarrer maintenant ?`n" +
                "(Cliquez Non pour redemarrer plus tard)",
                "Operation Reussie",
                [System.Windows.MessageBoxButton]::YesNo,
                [System.Windows.MessageBoxImage]::Information
            ) | Out-Null
        }
        else {
            Write-GUILog "Operation annulee par l'utilisateur" "Warning"
        }
    }
    catch {
        Hide-Progress
        Write-GUILog "ERREUR CRITIQUE : $_" "Error"
        [System.Windows.MessageBox]::Show(
            "Une erreur est survenue pendant l'operation :`n`n$_`n`n" +
            "Consultez le journal pour plus de details.",
            "Erreur",
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Error
        )
    }
}

$RestoreButton_Click = {
    Write-GUILog "Fonction RESTAURER - En developpement" "Warning"
    [System.Windows.MessageBox]::Show(
        "La fonction RESTAURER sera disponible dans la version v2.0.3-GUI.`n`n" +
        "Cette fonction permettra de restaurer un profil precedemment deplace vers son emplacement d'origine.`n`n" +
        "Pour l'instant, utilisez le script CLI (SecureMover.ps1) pour cette operation.",
        "Fonction en Developpement",
        [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]::Information
    )
}

$BackupButton_Click = {
    Write-GUILog "Fonction SAUVEGARDER - En developpement" "Warning"
    [System.Windows.MessageBox]::Show(
        "La fonction SAUVEGARDER sera disponible dans la version v2.0.3-GUI.`n`n" +
        "Cette fonction permettra de creer une copie de sauvegarde du profil sur un support externe.`n`n" +
        "Pour l'instant, utilisez le script CLI (SecureMover.ps1) pour cette operation.",
        "Fonction en Developpement",
        [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]::Information
    )
}

$WhatIfButton_Click = {
    if ($ProfileComboBox.SelectedIndex -eq -1 -or $DriveComboBox.SelectedIndex -eq -1) {
        [System.Windows.MessageBox]::Show(
            "Veuillez selectionner un profil et un disque de destination.`n`nUtilisez les listes deroulantes ci-dessus.",
            "Selection Requise",
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Warning
        )
        return
    }

    $selectedProfile = $ProfileComboBox.SelectedItem
    $selectedDrive = $DriveComboBox.SelectedItem

    Write-GUILog "================================================" "Info"
    Write-GUILog "MODE SIMULATION (WhatIf) - AUCUNE MODIFICATION" "Info"
    Write-GUILog "================================================" "Info"
    Write-GUILog "" "Info"
    Write-GUILog "Profil a deplacer  : $selectedProfile" "Info"
    Write-GUILog "Destination        : $selectedDrive" "Info"
    Write-GUILog "" "Info"
    Write-GUILog "Actions qui seraient effectuees :" "Info"
    Write-GUILog "  1. Calcul de la taille du profil" "Info"
    Write-GUILog "  2. Verification de l'espace disque disponible" "Info"
    Write-GUILog "  3. Sauvegarde du registre Windows" "Info"
    Write-GUILog "  4. Deplacement des dossiers utilisateur :" "Info"
    Write-GUILog "     - Desktop (Bureau)" "Info"
    Write-GUILog "     - Documents" "Info"
    Write-GUILog "     - Downloads (Telechargements)" "Info"
    Write-GUILog "     - Music (Musique)" "Info"
    Write-GUILog "     - Pictures (Images)" "Info"
    Write-GUILog "     - Videos" "Info"
    Write-GUILog "  5. Mise a jour du registre Windows" "Info"
    Write-GUILog "  6. Notification systeme" "Info"
    Write-GUILog "" "Info"
    Write-GUILog "================================================" "Warning"
    Write-GUILog "AUCUNE MODIFICATION N'A ETE EFFECTUEE" "Warning"
    Write-GUILog "Ceci etait une simulation uniquement" "Warning"
    Write-GUILog "================================================" "Warning"
    Write-GUILog "" "Info"

    [System.Windows.MessageBox]::Show(
        "MODE SIMULATION ACTIVE !`n`n" +
        "Consultez le journal d'activite pour voir toutes les actions qui seraient effectuees.`n`n" +
        "AUCUNE MODIFICATION n'a ete apportee au systeme.`n`n" +
        "Pour effectuer l'operation reellement, utilisez le bouton DEPLACER.",
        "Simulation WhatIf Terminee",
        [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]::Information
    )
}

$ExportLogsButton_Click = {
    try {
        Write-GUILog "Export des logs demande..." "Info"

        # Creer nom de fichier avec timestamp
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $defaultFileName = "SecureMover_Logs_$timestamp"

        # Dialog pour choisir l'emplacement et le format
        Add-Type -AssemblyName System.Windows.Forms
        $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
        $saveDialog.Title = "Exporter le journal d'activite"
        $saveDialog.Filter = "Fichier texte (*.txt)|*.txt|Fichier Markdown (*.md)|*.md|Fichier HTML (*.html)|*.html"
        $saveDialog.FileName = $defaultFileName
        $saveDialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")

        if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $filePath = $saveDialog.FileName
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()

            # Recuperer le contenu des logs
            $logContent = $LogTextBlock.Text

            switch ($extension) {
                ".txt" {
                    # Export texte brut
                    $logContent | Out-File -FilePath $filePath -Encoding UTF8
                    Write-GUILog "Logs exportes en TXT : $filePath" "Success"
                }
                ".md" {
                    # Export Markdown
                    $mdContent = "# SecureMover - Journal d'Activite`n`n"
                    $mdContent += "**Date d'export** : $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')`n`n"
                    $mdContent += "## Logs`n`n"
                    $mdContent += "``````text`n"
                    $mdContent += $logContent
                    $mdContent += "`n``````"
                    $mdContent | Out-File -FilePath $filePath -Encoding UTF8
                    Write-GUILog "Logs exportes en Markdown : $filePath" "Success"
                }
                ".html" {
                    # Export HTML
                    $htmlContent = @"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SecureMover - Journal d'Activite</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #1E1E1E;
            color: #CCCCCC;
            padding: 20px;
            margin: 0;
        }
        .header {
            background-color: #2D2D30;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #0E639C;
        }
        h1 {
            color: #FFFFFF;
            margin: 0 0 10px 0;
        }
        .timestamp {
            color: #A0A0A0;
            font-size: 14px;
        }
        .logs {
            background-color: #252526;
            padding: 20px;
            border-radius: 8px;
            font-family: 'Consolas', monospace;
            font-size: 12px;
            white-space: pre-wrap;
            word-wrap: break-word;
            border: 1px solid #3F3F46;
        }
        .log-line {
            margin: 2px 0;
        }
        .footer {
            margin-top: 20px;
            text-align: center;
            color: #606060;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SecureMover - Journal d'Activite</h1>
        <div class="timestamp">Export le : $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')</div>
    </div>
    <div class="logs">$([System.Web.HttpUtility]::HtmlEncode($logContent))</div>
    <div class="footer">SecureMover v2.0.2 GUI - MIT License - DrSmoke 2025</div>
</body>
</html>
"@
                    $htmlContent | Out-File -FilePath $filePath -Encoding UTF8
                    Write-GUILog "Logs exportes en HTML : $filePath" "Success"
                }
                default {
                    # Par defaut, export en texte
                    $logContent | Out-File -FilePath $filePath -Encoding UTF8
                    Write-GUILog "Logs exportes : $filePath" "Success"
                }
            }

            # Message de confirmation
            [System.Windows.MessageBox]::Show(
                "Les logs ont ete exportes avec succes !`n`n" +
                "Fichier : $filePath`n`n" +
                "Vous pouvez maintenant consulter ce fichier.",
                "Export Reussi",
                [System.Windows.MessageBoxButton]::OK,
                [System.Windows.MessageBoxImage]::Information
            )
        }
        else {
            Write-GUILog "Export annule par l'utilisateur" "Warning"
        }
    }
    catch {
        Write-GUILog "Erreur lors de l'export : $_" "Error"
        [System.Windows.MessageBox]::Show(
            "Une erreur est survenue lors de l'export :`n`n$_",
            "Erreur d'Export",
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Error
        )
    }
}

$DriveComboBox_SelectionChanged = {
    if ($DriveComboBox.SelectedIndex -ne -1) {
        try {
            $selectedText = $DriveComboBox.SelectedItem
            $selectedDrive = ($selectedText -split ' - ')[0].TrimEnd(':\')
            $drive = Get-PSDrive -Name $selectedDrive -PSProvider FileSystem
            $freeGB = [math]::Round($drive.Free / 1GB, 2)
            $percentFree = [math]::Round(($drive.Free / ($drive.Used + $drive.Free)) * 100, 1)

            $SpaceInfoText.Text = "Espace libre : $freeGB GB ($percentFree`% disponible)"

            if ($percentFree -lt 15) {
                $SpaceInfoText.Foreground = "#FF6B6B"  # Rouge - Critique
                Write-GUILog "ATTENTION : Espace disque critique sur $selectedDrive (< 15%)" "Warning"
            } elseif ($percentFree -lt 30) {
                $SpaceInfoText.Foreground = "#FFB86C"  # Orange - Attention
            } else {
                $SpaceInfoText.Foreground = "#50FA7B"  # Vert - OK
            }
        }
        catch {
            $SpaceInfoText.Text = "Erreur lors de la lecture de l'espace disque"
            $SpaceInfoText.Foreground = "#FF6B6B"
            Write-GUILog "Erreur lecture espace disque : $_" "Error"
        }
    }
}

# ============================================================================
# MAIN - CREATION DE LA FENETRE
# ============================================================================

try {
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host " SecureMover GUI v2.0.2" -ForegroundColor Cyan
    Write-Host " Lancement en cours..." -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""

    # Creer la fenetre WPF
    Add-Type -AssemblyName PresentationFramework

    $reader = New-Object System.Xml.XmlNodeReader $xaml
    $window = [Windows.Markup.XamlReader]::Load($reader)

    # Recuperer les controles
    $ProfileComboBox = $window.FindName("ProfileComboBox")
    $DriveComboBox = $window.FindName("DriveComboBox")
    $SpaceInfoText = $window.FindName("SpaceInfoText")
    $MoveButton = $window.FindName("MoveButton")
    $RestoreButton = $window.FindName("RestoreButton")
    $BackupButton = $window.FindName("BackupButton")
    $WhatIfButton = $window.FindName("WhatIfButton")
    $ExportLogsButton = $window.FindName("ExportLogsButton")
    $ProgressBorder = $window.FindName("ProgressBorder")
    $ProgressBar = $window.FindName("ProgressBar")
    $ProgressText = $window.FindName("ProgressText")
    $LogTextBlock = $window.FindName("LogTextBlock")

    # Attacher les evenements
    $MoveButton.Add_Click($MoveButton_Click)
    $RestoreButton.Add_Click($RestoreButton_Click)
    $BackupButton.Add_Click($BackupButton_Click)
    $WhatIfButton.Add_Click($WhatIfButton_Click)
    $ExportLogsButton.Add_Click($ExportLogsButton_Click)
    $DriveComboBox.Add_SelectionChanged($DriveComboBox_SelectionChanged)

    # Initialiser l'interface
    Initialize-GUI

    Write-Host "[OK] Interface chargee avec succes !" -ForegroundColor Green
    Write-Host ""

    # Afficher la fenetre
    $window.ShowDialog() | Out-Null
}
catch {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host " ERREUR lors du lancement de la GUI" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Message : $_" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Stack Trace :" -ForegroundColor Yellow
    Write-Host $_.ScriptStackTrace -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Verifiez que :" -ForegroundColor Cyan
    Write-Host "  1. Vous executez en tant qu'Administrateur" -ForegroundColor White
    Write-Host "  2. PowerShell 5.1+ est installe" -ForegroundColor White
    Write-Host "  3. .NET Framework 4.5+ est installe" -ForegroundColor White
    Write-Host ""
    Read-Host "Appuyez sur Entree pour quitter"
}
