# 🚀🎨 CI4 Docker SDK 🎨🚀

This script provides a **funky & stylish** way to manage a Dockerized CodeIgniter 4 (CI4) environment. It helps **start, stop, and interact** with CI4 containers **effortlessly!** 🎉

---

## 🎭 Prerequisites 🎭

Ensure you have the following installed on your system:
✅ **Docker** 🐳  
✅ **Docker Compose** 📦  
✅ **Bash** 💻  

---

## 🌟 Features 🌟

✨ Starts or restarts CI4 Docker containers automatically 🚀  
✨ Stops all running containers 🛑  
✨ Provides a CLI interface to interact with the CI4 application 🎤  
✨ Bootstraps the project setup 🏗️  

---

## 🎬 Usage 🎬

The script supports the following **funky commands**:

### ⚡ Bootstrap Project Setup ⚡
```sh
🚀 docker/sdk boot
```
🛠 Runs the bootstrap function to set up the CI4 project.

### 🎯 Start Containers 🎯
```sh
🔥 docker/sdk up
```
🔧 Ensures all necessary CI4 containers (`ci4-php`, `ci4-nginx`, `ci4-mariadb`, `ci4-phpmyadmin`) are **running smoothly**. If a container is not found, it will be **built and started**. The application will be accessible at `your-host:8081`.

### 🛑 Stop Containers 🛑
```sh
❌ docker/sdk down
```
💥 Stops and removes all running CI4 Docker containers.

### 🖥️ Open CI4 CLI 🖥️
```sh
💻 docker/sdk cli
```
🔎 Opens a shell inside the `ci4-php` container, allowing you to interact with the CodeIgniter 4 application using the CLI.

---

## 🎨 Additional Information 🎨

🎭 The script includes a **visual banner** upon execution.  
🎨 It uses **color-coded messages** to indicate actions being performed.  
🔍 It checks whether a container **exists** before attempting to start or restart it.

---

## 🤩 Author 🤩
**Chandan Kumar** 🎩 (<ranjanpratik@yahoo.in>)

🔥 _Happy Coding!_ 🔥

