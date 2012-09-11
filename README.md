CocosLib
========

The idea behind this project is to allow Cocos2D and Box2D to be easily compiled and packaged into a compact and easily embeddable form.

General Notes
-------------

Current patches applied and changes from Cocos2D's master-v2 branch (20120820).

1.) PVRv3 format support from develop-v2.

2.) Removed some font related forward declarations (merged in develop-v2 check if this has already been brought in master-v2)… tFontDefHashElement and KerningHashElement… 

https://github.com/cocos2d/cocos2d-iphone/commit/89244ec00d85245dcc074d8aade573c610fbab47

3.) Support for animated transitions when pushing or popping scenes:
https://github.com/cocos2d/cocos2d-iphone/pull/230

4.) Optimisation - eliminated costly [NSNumber floatValue] calls
https://github.com/cocos2d/cocos2d-iphone/pull/232

5.) CCGLProgram guards, fixes and debugging info
https://github.com/cocos2d/cocos2d-iphone/pull/212

	Added some further fixes: 
		https://github.com/iomac/cocos2d-iphone/commit/c3f1ffb2a47402acf351da6fff33e8cf83fe0258#commitcomment-1737403
		https://github.com/Panajev/CocosLib/commit/f978aa38b5b4a50797cc856a1a67f391589b9cf3 

6.) Rendering Target Node - Rendering to texture made simpler.
https://github.com/cocos2d/cocos2d-iphone/pull/231

7.) Fix for issue #1398: Double firing of CCCallBlock in CCSequence.
https://github.com/cocos2d/cocos2d-iphone/pull/233

8.) Fixed CCSprite's displayFrame function not returning the correct frame in Retina mode (taken from develop-v2).
    https://github.com/cocos2d/cocos2d-iphone/commit/ec7cc1c7437dc4a590de7b8103504d4aa00b4503

9.) Added the ability to turn off debug drawing for a CCSprite node or any of its subclasses at runtime.
    

HOWTO Install
-------------

In order to download and use this library in your project and all the other helper libraries I usually rely on with other applications of mine, you can use the following script (or you can fork each, then clone, and build each of them using the script target):

```
#!/bin/bash
#Do we need to download the code from GitHub? 
#Set to false to just build the library again after successfully cloning the repo's.
DOWNLOAD_GIT="TRUE"

#To download the latest tag
SAFE_TAG=("" "" "")

#To download a specific tag
#SAFE_TAG=("v1.1.2" "v1.2.8" "1.1.6")

LIBS=("Utilities ${SAFE_TAG[0]}" "CocosLib ${SAFE_TAG[1]}" "CocosTools ${SAFE_TAG[2]}")
rm -rf ~/Programming/SharedLibs

for f in "${LIBS[@]}"; do
    set -- $f
    echo

    if [ "$DOWNLOAD_GIT" == "TRUE" ]; then
        git clone https://github.com/Panajev/"$1".git "$1"
    fi
    #echo "$1 $2"

    cd "$1"
    if [ "$DOWNLOAD_GIT" == "TRUE" ]; then
        if [ x"$2" != x ]; then
            echo Checking out tag "$2"
            git checkout -b localBranch_"$1" "$2"
        else
            echo Checking out latest version
        fi
    fi

    echo Processing "$1"_script
    /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild clean -target "$1"_script
    /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild build -target "$1"_script
    cd ..
done
```




