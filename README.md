# ubuntu-env
Installs common packages that I use to get up and running with a new Ubuntu install. 

This will use `apt` to install any packages in the `apt-packs.txt` file.
If you need to add a `ppa` cert to your machine, then it will also handle
that, just throw it in the same text file (see Lutris for example).

This also downloads [OhMyZsh](https://github.com/ohmyzsh/ohmyzsh) and sets
it as the default via `chsh`

```
OVERVIEW: Installs any packages and adds any PPA's in the 'apt-packs.txt' file.
 
OPTIONS:
	-h	Help. Prints this message!
	-d	Dry Run. If this flag is set then nothing will actually be installed, only printed out to the screen
```

Probably would have been easier to do this in python, but python is one of the packages
that this installs so ¯\_(ツ)_/¯