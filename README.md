# weight_tracker

A new Flutter project.

## Getting Started

This project uses FVM (Flutter Version Manager). You can install it by running:

```
dart pub global activate fvm
```

Be sure to add the pub-cache .bin to your path via config file (.bashrc, .bash_profile, .zshrc, etc.) so you can use FVM. Copy and paste this snippet below in your appropriate config file on Mac. [Windows 10/11 path setup here](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/)

```
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

After pulling the repo, and installing fvm, run the following command. This will install the targeted flutter version locally to the project to be used via `fvm flutter` commands.

```
fvm install
```

<span style="color: red; font-weight: bold; text-decoration: underline">NOTE:</span> This means that `flutter run` is replaced with `fvm flutter run`. All other `flutter _____` commands should be `fvm flutter ____` as well. For more info check out [the fvm documentation](https://fvm.app/docs/getting_started/overview)
