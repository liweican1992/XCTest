#!/bin/sh

#  UITest.sh
#  UDictionary
#
#  Created by 李伟灿 on 2021/8/24.
#  Copyright © 2021 com.youdao. All rights reserved.


#chmod +x UITest.sh
#./UITest.sh

echo "=========开始执行========="

path=$(pwd)
echo "path is $path"

scheme="UDictionary"

#输出目录
outPath="$HOME/Desktop/outData"
resultPath="$HOME/Desktop/outResult"

#XCUITest function
xcUITestFunc(){

    if test -e $scheme.xcodeproj
    then
        echo '=========Xcode Project存在'
    else
        echo '=========Xcode Project不存在 请检查执行路径'
        exit
    fi



    if test -e $outPath
    then
        echo "=========outPath existed, clean outPath"
        rm -rf $outPath
    fi

    mkdir $outPath
    echo "=========outPath mkdir"

    #Get All Devices

    #xcrun xctrace list devices

    #兼容真机和模拟器 不过最好模拟器一起跑 真机一起跑
    simulators=("platform=iOS Simulator,name=iPhone 12 Pro Max,OS=14.5"
                "platform=iOS Simulator,name=iPhone 12,OS=14.5"
                "platform=iOS Simulator,name=iPhone 8 Plus,OS=14.5"
                "platform=iOS Simulator,name=iPhone 8,OS=14.5"

                #"platform=iOS,name=iPhone"
                )

    destinationStr=""

    for subSimulator in "${simulators[@]}"
    do
        tmpStr="-destination '$subSimulator' "
        destinationStr=$destinationStr$tmpStr
    done
        echo $destinationStr

    #拼接命令
    commandStr="xcodebuild test -workspace $scheme.xcworkspace -scheme $scheme -derivedDataPath '$outPath' $destinationStr"

    echo $commandStr

    #执行命令
    eval $commandStr

    echo "=========XCTestPlan执行结束========="
    echo "----------------------------------"
    echo "----------------------------------"

}


getAllScreenShots(){

    if test -e $resultPath
    then
        echo "=========resultPath existed, clean resultPath"
        rm -rf $resultPath
    fi

    #find xcresult
    xcresultpath=$(find $outPath/Logs/Test -name "*.xcresult")


    echo "=========即将输出图片到$resultPath"

    #Install xcparse
    #brew install chargepoint/xcparse/xcparse

    #执行xcparse
    commandStr="xcparse screenshots --os --model --test-plan-config $xcresultpath $resultPath"
    echo $commandStr

    #执行命令
    eval $commandStr

    echo "=========xcparse执行结束========="

}


xcUITestFunc

getAllScreenShots









