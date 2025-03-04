#!/bin/bash
pip3 install -U PyInstaller

echo "purging ./dist/"
rm -rf dist/

python -m PyInstaller --onefile -n "sigma-$(arch)" main.py --exclude-module tkinter --exclude-module unittest --exclude-module pytest --clean --optimize 2

echo "executable at dist/sigma-$(arch)"

# set -euo pipefail

# rm -rf temp dist
# mkdir -p temp

# pip install -U -r requirements.txt

# python setup.py build_ext --build-lib=temp --build-temp=temp/build_cython --inplace

# mv ./*.so ./temp/

# python -m PyInstaller \
#     --onefile main.py \
#     -n sigma \
#     --distpath=./dist \
#     --workpath=temp/build_pyinstaller \
#     --specpath=temp \
#     --clean \
#     --upx-dir=/usr/bin \
#     --exclude-module tkinter \
#     --exclude-module unittest \
#     --exclude-module pytest \
#     --hidden-import=colorama \
#     --hidden-import=tqdm \
#     --hidden-import=helpers \
#     --hidden-import=loaders \
#     --hidden-import=loggers \
#     --add-binary "./lexer*.so:." \
#     --add-binary "./parser*.so:." \
#     --add-binary "./evaluator*.so:." \
#     --optimize 2

strip --strip-all dist/sigma

echo -e "\nexecutable size: \n$(du -sh dist/sigma-$(arch))"

echo -e "\nmove to /usr/bin (ENTER) or exit (anything else)?"
read -r CONTINUE < /dev/tty
if [ -n "$CONTINUE" ]; then
    echo "build at dist/sigma-$(arch)"
    exit 0
fi


sudo mv "./dist/sigma-$(arch)" "/usr/bin/sigma"