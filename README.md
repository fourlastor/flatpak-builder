# Flatpak Local Repository Builder

This repository provides tools to create a local Flatpak repository (suitable for USB distribution) packaged as a ZIP file. This is useful for installing Flatpaks on systems without an internet connection.

## 🚀 How to use via GitHub Actions (Recommended)

1.  **Clone the repository** to your own GitHub account (if you want to run it on your own infrastructure).
2.  Navigate to the **Actions** tab in the repository.
3.  On the left-side menu, click on the workflow named **Flatpak Local Repo Builder**.
4.  Click the **Run workflow** dropdown button.
5.  Enter the **Flatpak Package ID** you wish to bundle (e.g., `org.gnome.gedit`).
6.  Click **Run workflow**.
7.  Once the workflow completes, go to the **Releases** page of your repository to download the generated ZIP file.

## 🐳 How to use via Docker (Local)

If you prefer to run the builder locally on your machine:

1.  **Build the Docker image**:
    ```bash
    docker build -t flatpak-builder .
    ```
2.  **Run the builder**:
    ```bash
    mkdir -p out
    docker run --rm -v $(pwd)/out:/output flatpak-builder org.gnome.gedit
    ```
3.  The generated `flatpak-local.zip` will be located in the `out/` directory.

## ⬇️ How to install on the target system

Once you have the `flatpak-local.zip` file:

1.  **Transfer the ZIP file** to the target system (e.g., via USB).
2.  **Extract the ZIP file**:
    ```bash
    unzip flatpak-local.zip -d my-flatpak-bundle
    ```
3.  **Install the package** using the `--sideload-repo` flag:
    ```bash
    # Ensure the Flathub remote is configured (even if offline)
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    # Install using the local repository as a source
    flatpak install --sideload-repo=$(pwd)/my-flatpak-bundle/.ostree/repo flathub <package-id>
    ```

## 📦 What's inside the bundle?

The generated ZIP file contains an OSTree repository with the specified application and all its required runtimes and dependencies from Flathub.
