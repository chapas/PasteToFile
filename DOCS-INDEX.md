# PasteToFile - Documentation Index

Quick reference guide to all PasteToFile documentation files.

---

## 📚 Documentation Map

### For End Users

#### [README.md](README.md)
**Start here if you're using PasteToFile**

- 📋 Feature overview
- ⚙️ System requirements
- 🚀 **Quick installation** (3 methods)
- 📖 Usage instructions
- ❓ FAQ
- 🔧 Troubleshooting basics

**Time to read:** 5 minutes  
**Audience:** All users  
**Contains:** How to install and use

---

### For Developers & Installers

#### [QUICKSTART.md](QUICKSTART.md)
**TL;DR - Build installer in 5 minutes**

- ⚡ Quick prerequisites
- 🔧 One-command build
- 📦 Output verification
- ✅ Common tasks

**Time to read:** 2 minutes  
**Audience:** Developers who know the basics  
**Contains:** Fastest path to working installer

---

#### [INSTALLER-GUIDE.md](INSTALLER-GUIDE.md)
**Complete installer creation and deployment guide**

**10 Major Sections:**
1. Overview & prerequisites
2. **4 Build methods** (PowerShell, Batch, Interactive, Manual)
3. Build output structure
4. Customization options (version, directory, icons, compression)
5. Distribution methods (GitHub, web, enterprise, silent)
6. Comprehensive troubleshooting (build, install, runtime)
7. Advanced topics:
   - CI/CD automation (GitHub Actions)
   - Silent deployment scripts
   - Batch enterprise deployment
   - Custom post-install behavior
   - Code signing
8. Complete FAQ (15+ questions)
9. Performance tips
10. Security considerations

**Time to read:** 30 minutes (or jump to sections needed)  
**Audience:** Developers, IT admins, DevOps  
**Contains:** Everything about installers

---

#### [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
**Standalone troubleshooting reference**

**8 Sections with Solutions:**
1. Build process (6 problems: project not found, SDK, Inno, policies, access, etc.)
2. Installation (2 problems: runtime, admin prompts)
3. Runtime (1 problem: app won't start)
4. Context menu (2 problems: missing, duplicates)
5. Uninstallation (1 problem)
6. Registry issues (2 problems)
7. Performance & optimization
8. How to report bugs

**Time to read:** 15 minutes (search problem)  
**Audience:** Anyone with issues  
**Contains:** Problem → Solution format

---

## 🎯 Finding What You Need

### "I want to..."

| Goal | Start Here | Time |
|------|-----------|------|
| **Install PasteToFile** | [README.md](README.md#installation-methods) | 5 min |
| **Build installer quickly** | [QUICKSTART.md](QUICKSTART.md) | 2 min |
| **Understand all build options** | [INSTALLER-GUIDE.md](INSTALLER-GUIDE.md#creating-the-installer) | 10 min |
| **Customize installer (version, path, etc)** | [INSTALLER-GUIDE.md](INSTALLER-GUIDE.md#customizing-the-installer) | 15 min |
| **Deploy to enterprise** | [INSTALLER-GUIDE.md](INSTALLER-GUIDE.md#advanced-topics) | 20 min |
| **Fix a build error** | [TROUBLESHOOTING.md](TROUBLESHOOTING.md#build-process-troubleshooting) | 5 min |
| **Fix installer issue** | [TROUBLESHOOTING.md](TROUBLESHOOTING.md#installation-issues) | 5 min |
| **Setup GitHub Actions CI/CD** | [INSTALLER-GUIDE.md](INSTALLER-GUIDE.md#github-actions-cicd-automation) | 10 min |
| **Sign the installer** | [INSTALLER-GUIDE.md](INSTALLER-GUIDE.md#security-considerations) | 5 min |
| **Answer FAQs** | [INSTALLER-GUIDE.md](INSTALLER-GUIDE.md#faq) | 10 min |

---

## 📁 File Organization

```
C:\src\PasteToFile\
├── README.md                     (User guide & quick start)
├── QUICKSTART.md                 (5-minute installer build)
├── INSTALLER-GUIDE.md            (Complete reference - 60KB)
├── TROUBLESHOOTING.md            (Problem solving - 45KB)
├── DOCS-INDEX.md                 (This file)
│
├── build-installer.ps1           (PowerShell build automation)
├── build-installer.bat           (Batch build automation)
├── build.bat                     (Interactive menu)
├── PasteToFile.iss               (Inno Setup configuration)
│
└── Program.cs                    (Source code)
```

---

## 🚀 Recommended Reading Order

### First-Time User Setup

1. **[README.md](README.md)** (5 min)
   - Understand what PasteToFile does
   - See system requirements
   - Choose installation method

2. **[QUICKSTART.md](QUICKSTART.md)** (2 min)
   - Get installer built in 5 minutes

3. **Done!** Start using it ✅

---

### Building for Distribution

1. **[QUICKSTART.md](QUICKSTART.md)** (2 min)
   - Verify prerequisites

2. **[INSTALLER-GUIDE.md](INSTALLER-GUIDE.md)** (20 min)
   - Learn all build methods
   - Customize for your needs
   - Plan distribution

3. **[INSTALLER-GUIDE.md - Distribution](INSTALLER-GUIDE.md#distribution-methods)** (5 min)
   - Choose distribution method
   - Implement

---

### Troubleshooting Issues

1. **Search [TROUBLESHOOTING.md](TROUBLESHOOTING.md)**
   - Find your error
   - Follow solution

2. **If not found:**
   - Check [INSTALLER-GUIDE.md FAQ](INSTALLER-GUIDE.md#faq)
   - Check [README.md FAQ](README.md#faq)

3. **Still stuck?**
   - Report issue on GitHub with details

---

## 📊 Documentation Statistics

| Document | Lines | Size | Focus |
|----------|-------|------|-------|
| README.md | 307 | 12 KB | Users & quick start |
| QUICKSTART.md | 75 | 3 KB | 5-minute reference |
| INSTALLER-GUIDE.md | 1600+ | 60 KB | Comprehensive reference |
| TROUBLESHOOTING.md | 900+ | 45 KB | Problem solving |
| **TOTAL** | **2,882+** | **120 KB** | **Complete** |

---

## 🔗 Key Sections by Topic

### Installation
- [README.md - Installation Methods](README.md#installation-methods) (3 methods for users)
- [INSTALLER-GUIDE.md - Creating Installer](INSTALLER-GUIDE.md#creating-the-installer) (4 methods for developers)
- [QUICKSTART.md](QUICKSTART.md) (Fastest path)

### Customization
- [INSTALLER-GUIDE.md - Customizing](INSTALLER-GUIDE.md#customizing-the-installer)
  - Version numbers
  - Installation paths
  - Compression settings
  - Components
  - Icons

### Distribution
- [INSTALLER-GUIDE.md - Distribution Methods](INSTALLER-GUIDE.md#distribution-methods)
  - Direct sharing
  - GitHub Releases
  - Website hosting
  - Enterprise deployment

### Troubleshooting
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - All problems
- [INSTALLER-GUIDE.md - Troubleshooting](INSTALLER-GUIDE.md#troubleshooting) - Build-specific
- [README.md - Troubleshooting](README.md#troubleshooting) - Usage issues

### Advanced Topics
- [INSTALLER-GUIDE.md - Advanced Topics](INSTALLER-GUIDE.md#advanced-topics)
  - CI/CD automation
  - Silent installation
  - Batch deployment
  - Version management
  - Code signing

### Security
- [INSTALLER-GUIDE.md - Security](INSTALLER-GUIDE.md#security-considerations)
  - Code signing
  - Checksum verification
  - Safe scripting practices

### Performance
- [INSTALLER-GUIDE.md - Performance](INSTALLER-GUIDE.md#performance-tips)
- [TROUBLESHOOTING.md - Performance](TROUBLESHOOTING.md#performance--optimization)

---

## 💡 Pro Tips

### For Quick Builds
```powershell
# Fastest path: use PowerShell with skip-build
.\build-installer.ps1 -SkipBuild
```

### For Debugging
```powershell
# Manual build gives more control
.\build-installer.ps1 -OpenOutput:$false
```

### For Distribution
- Host on **GitHub Releases** for automatic updates
- Use **batch deployment scripts** for enterprise
- Enable **code signing** for trust

### For Support
- Provide system info from [TROUBLESHOOTING.md](TROUBLESHOOTING.md#information-to-collect)
- Include steps to reproduce
- Mention version of PasteToFile

---

## 📞 Support Resources

| Resource | Purpose | Link |
|----------|---------|------|
| **README.md** | Getting started | [Read](README.md) |
| **QUICKSTART.md** | Fast build | [Read](QUICKSTART.md) |
| **INSTALLER-GUIDE.md** | Complete reference | [Read](INSTALLER-GUIDE.md) |
| **TROUBLESHOOTING.md** | Problem solving | [Read](TROUBLESHOOTING.md) |
| **GitHub Issues** | Report bugs | https://github.com/chapas/PasteToFile/issues |
| **GitHub Discussions** | Questions | https://github.com/chapas/PasteToFile/discussions |

---

## 🎓 Learning Paths

### Path 1: Just Want to Use It
```
README.md (5 min) → Install → Done ✅
```

### Path 2: Build & Deploy
```
QUICKSTART.md (2 min) → INSTALLER-GUIDE.md (20 min) → Distribute ✅
```

### Path 3: Troubleshoot Issues
```
TROUBLESHOOTING.md (search problem) → Follow solution ✅
```

### Path 4: Advanced Setup (Enterprise)
```
INSTALLER-GUIDE.md → Advanced Topics → CI/CD → Implement ✅
```

---

## ✅ Checklist: Before Distributing

- [ ] Read [INSTALLER-GUIDE.md](INSTALLER-GUIDE.md)
- [ ] Successfully built installer with `./build-installer.ps1`
- [ ] Tested installer on clean system
- [ ] Verified "Paste to file" works after installation
- [ ] Decided on distribution method
- [ ] Chose version number (e.g., v1.0.0)
- [ ] Tested uninstall/reinstall
- [ ] (Optional) Set up CI/CD with GitHub Actions
- [ ] (Optional) Signed installer for trust
- [ ] Ready to distribute! 🚀

---

## 📝 Version History

**Current:** June 2026
- All documentation complete
- Production-ready
- Comprehensive guides
- Extensive troubleshooting

---

**Questions?** Start with [README.md](README.md) or search [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

**Last Updated:** June 2026  
**Status:** Complete & Current ✅
