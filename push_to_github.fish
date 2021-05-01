#! /usr/bin/fish

rm -rf ./home
mkdir ./home

rm -rf ./system
mkdir ./system

cp -r $HOME/.config/nixpkgs/. ./home
cp -r /cfg/. ./system

git add .
git commit -m (date +%Y-%m-%d)
git push
