const { app, BrowserWindow } = require('electron')
const path = require('path')

const createWindow = () => {
    // Créez la fenêtre du navigateur.
    const mainWindow = new BrowserWindow({
        width: 800,
        height: 600,
        webPreferences: {
            preload: path.join(__dirname, 'preload.js')
        }
    })
    // Et charger l'index.html de l'application.
    mainWindow.loadFile('src/index.html')
    // Ouvrir les outils de développement.
    // mainWindow.webContents.openDevTools()
}

// Cette méthode sera appelée quand Electron aura fini de s'initialiser et sera prêt à créer des fenêtres de navigation.
// Certaines APIs peuvent être utilisées uniquement quant cet événement est émit.
app.whenReady().then(() => {
    createWindow()
    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) createWindow()
    })
})

// Quitter quand toutes les fenêtres sont fermées.
app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit()
})
