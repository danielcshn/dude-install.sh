<div align="center">
  <h3 style="font-size: xx-large;"> dude-install.sh </h3>
  <hr>
  <p>The main purpose of this tool is to automate the installation of The Dude Client in Linux.<br>Current support for Debian, Ubuntu, Linux Lite & Linux Mint.</p>
  <hr>
</div>

<div align="center">
  
[![GitHub issues](https://img.shields.io/bitbucket/issues/danielcshn/dude-install.sh?style=for-the-badge)](https://github.com/danielcshn/dude-install.sh/issues)
[![GitHub watchers](https://img.shields.io/github/watchers/danielcshn/dude-install.sh?style=for-the-badge)](https://github.com/danielcshn/dude-install.sh/watchers)
[![GitHub forks](https://img.shields.io/github/forks/danielcshn/dude-install.sh?style=for-the-badge)](https://github.com/danielcshn/dude-install.sh/fork)
[![GitHub stars](https://img.shields.io/github/stars/danielcshn/dude-install.sh?style=for-the-badge)](https://github.com/danielcshn/dude-install.sh/stargazers)
[![License](https://img.shields.io/github/license/danielcshn/dude-install.sh?style=for-the-badge)](https://github.com/danielcshn/dude-install.sh/blob/main/LICENSE)
[![Language](https://img.shields.io/github/languages/top/danielcshn/dude-install.sh?style=for-the-badge)](https://github.com/danielcshn/dude-install.sh/search?l=shell)
[![GitHub last commit](https://img.shields.io/github/last-commit/danielcshn/dude-install.sh?style=for-the-badge)](https://github.com/danielcshn/dude-install.sh/commits/main) [![Mikrotik Community](https://img.shields.io/badge/mikrotik-community-ff40f4?style=for-the-badge&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAACDVBMVEUAAAApMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkpMjkmLzcuNz0vOD9mbHG7vsAsNTyXm5/39/f////09PWytbhXXmMqMzonMDcoMTgqMjlYX2S1uLr19fXt7e6hpKhKUVcnMTgzPEMmLzYmMDcuNz5obnPEx8n6+vrj5OWPk5c/R015f4PNz9C8v8Fkam8tNj00PUN4foLT1Nb8/Pz9/f3X2dp5foNdZGnz9PTz8/Svs7VVXGEkLTQ9RUy+wcPy8/MnMDhGTVO2ubv29vbr7O2eoqVIUFadoaTs7e1vdXolLzYrNDszPEJnbnPGycvh4uOWm57+/v5gZ2yxtLdZX2U4QEd6gITV19jU1teIjZHb3N7w8fGPlJc+RkyMkZXi4+SNkZUvNz7Lzc8xOkFNVFrT1dYyOkHMztAoMjmgpKehpKcoMTmfoqZaYWfw8PEtNTzS09XHycs7REpWXWMsNDs8REqfo6aanqJPVlyws7aCy3k4AAAAPnRSTlMAAA9dr14HR7T2AzWi8QEmjegaeN0QY879Tr36DpD0+4+Yjln5C4TvBUKyVsQTa9T+HoDhLJXsBDyo8gpQn6Ds3aMAAAABYktHREdgvcl7AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5gUJDDU0M75dogAAAiNJREFUOMt1k4dXE0EQxrNIAqGE3ktoofdeh6aOZc+uS+wdT7FhDxqiggp2RQlClC5I+Rvda+ESjnnv3pv55nffvrc7YzJtBSEhu0JDzSGEmIyCEEtYuBXAGh5mMUJIRGRUNMgRHRUZEUwQW0xsHPgjLjbGRgLc4xMSISASE+L95xCSlJySquidXV2dSpaakpykIMSSlp6h/tfd09vboyEZ6WkWTpDMrGzNd/eevYj79h84SJU6OyuTmIjZLhcC/w4dPnIUEY8dPyGclEW7mQM5ckpPdTOAPufpM2c5cu78BcUkhwO5UuK8eOnylat9AOza9f4biOLNW05Jz1UBNnAb8c7de0BBuD/4gHvgwwGmAx49fvKUi89cQ5QOPX8hAaJ7WAeA5+Wr19LhI6OjI1L3TRDA3r4bG3//QUQ5xI+fPgcBw27xy1fh2/cJqT/xY/Dn5HYAJ72UTvUj/pqidHrGAJiZ9gH7jfiHgW8HYBaoC9FFYXZnYA5xzghg8wvBwMK8/qJg0b207PVpgM+7vORe1K46T34V9ndlFTQAVlf+MVnO40B+gfLc0vPRNcQ1ORFksSCfA47CIv8k0nXEdeoviwod0kgVl5RaVUXY2NzcENTCWlpSrAwlcZSV21ULj0c1sJeXOXRzXVFZVa2f+uqqygoSuBk1tXVb/braGrJ9t+obGpV2Y0O9zWh/SVNzSytAa0tzk/F683Pa2js62tsC3P8DrFHmOXeqdOkAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjItMDUtMDlUMTI6NTM6NTIrMDA6MDB5cXAnAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIyLTA1LTA5VDEyOjUzOjUyKzAwOjAwCCzImwAAAFd6VFh0UmF3IHByb2ZpbGUgdHlwZSBpcHRjAAB4nOPyDAhxVigoyk/LzEnlUgADIwsuYwsTIxNLkxQDEyBEgDTDZAMjs1Qgy9jUyMTMxBzEB8uASKBKLgDqFxF08kI1lQAAAABJRU5ErkJggg==)](https://forum.mikrotik.com/viewtopic.php?t=188816)

</div>

<p align="center">
  <img src="https://github.com/danielcshn/dude-install.sh/raw/main/imgs/dude-installer_scrs1.png" title="dude-install.sh">
</p>

## ✅ Support

- Debian 11 (Bullseye)
- Debian 10 (Buster)
- Ubuntu 22.04 (Jammy Jellyfish)
- Ubuntu 21.10 (Impish Indri)
- Ubuntu 20.04 (Focal Fossa)
- Ubuntu 18.04 (Bionic Beaver)
- Linux Lite 6.0 (Based on Ubuntu 22.04)
- Linux Mint 21 (Vanessa)
- Linux Mint 20 (Ulyana)
- Link Mint 19 (Tara)

## ⬇️ Installing
+ **For Linux :**
```
git clone https://github.com/danielcshn/dude-install.sh.git
cd dude-install.sh
chmod +x dude-install.sh
./dude-install.sh
```

## 🛠️ Usage

1. Select the `Check Dependencies` option to verify that you meet the required system and dependencies.

2. Select the `Install The Dude Client` option. Then indicate the version to install. Example: `7.1` or `7.5beta11`.

3. Select the `Launch The Dude Client` option to start the program.

<p align="center">
  <img src="https://img.shields.io/badge/%E2%9A%A0%20WARNING:%20This%20Script%20comes%20with%20ABSOLUTELY%20NO%20WARRANTY!%20-red?style=for-the-badge" title="Warning">
</p>

## 🧪 Tested distros

<div align="center">

[![Debian 11](https://img.shields.io/badge/Debian%2011-%E2%9C%85-blue?style=for-the-badge&logo=debian)](https://debian.org/) [![Ubuntu 22.04](https://img.shields.io/badge/Ubuntu%2022.04-%E2%9C%85-blue?style=for-the-badge&logo=ubuntu)](https://ubuntu.com/) [![Ubuntu 18.04.6](https://img.shields.io/badge/Ubuntu%2018.04.6-%E2%9C%85-blue?style=for-the-badge&logo=ubuntu)](https://ubuntu.com/) [![Linux Lite 6.0 (Ubuntu 22.04 LTD)](https://img.shields.io/badge/Linux%20Lite%206.0-%E2%9C%85-blue?style=for-the-badge&logo=ubuntu)](https://linuxliteos.com/) [![Linux Mint 21](https://img.shields.io/badge/Linux%20Mint%2021-%E2%9C%85-blue?style=for-the-badge&logo=linuxmint)](https://linuxmint.com/)

</div>

---

## 🤝 Contributing

We currently accept contributions to this repository.<br>Follow the steps below to make a contribution to the digital tool:

1. Fork the repository.
2. Develop the new functionality or make the changes that you think add value to the tool
3. Make a "pull request" documenting in detail the proposed changes in the repository.

**If you haven't contributed to the repository, but found the tool useful, we'd love to hear about your experience. Tell us about your experience in an Issue.**

#### Attributions
Tell us in the "pull request" your username and organization to add it to the list of contributions in the Readme.md.

---

## 📝 License

```
MIT License

Copyright (c) 2022 danielcshn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 📧 Contact

- Project Link: [https://github.com/danielcshn/dude-install.sh](https://github.com/danielcshn/dude-install.sh)
