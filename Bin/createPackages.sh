#!/bin/sh

############################
##change current directory
############################
if [ `echo $0 | grep -c  "/"` -gt 0 ];then
    cd ${0%/*}
fi

schemeName="Dentist"
binDir=`pwd`
destinationDir="`pwd`/../packages"                      ###最终生成文件目录
projectName="`pwd`/../Dentist.xcodeproj"
workspaceName="`pwd`/../Dentist.xcworkspace"
buildDir="`pwd`/../build"

buildCmdReturn=0

function createPackage()
{
    lowercaseModeArg=`echo $1 | tr '[A-Z]' '[a-z]'`

	shownName=""
    if [ "debug" = ${lowercaseModeArg} ]; then
        echo "\n\nDebug package generating.................\n\n"
        configurationName="Debug"
        shownName="Debug"
    elif [ "release" = ${lowercaseModeArg} ]; then
        echo "\n\nRelease package generating.................\n\n"
        configurationName="Release"
		shownName="RC"
    else
        echo "\n\nDistribute package generating.................\n\n"
        configurationName="Distribute"
		shownName="Distribute"
    fi

	buildNumberSuffix=""
	
    xcodebuild clean
    xcodebuild -workspace $workspaceName -scheme $schemeName -derivedDataPath ./build/ -destination generic/platform=iOS -configuration ${configurationName} clean build -sdk iphoneos

    buildCmdReturn=$?
    echo "编译结果:${buildCmdReturn}"
	
    # 生成ipa文件
    xcrun --sdk iphoneos PackageApplication -v ${buildDir}/Build/Products/${configurationName}-iphoneos/Dentist.app -o ${destinationDir}/Dentist-${configurationName}.ipa

    newFileDateName=`date "+%Y-%m-%d_%H:%M:%S"`
	
    if [ -d ${buildDir}/Build/Products/${configurationName}-iphoneos/Dentist.app.dSYM ]; then
        cp -r ${buildDir}/Build/Products/${configurationName}-iphoneos/Dentist.app.dSYM ${destinationDir}/Dentist-${configurationName}.app.dSYM
		
        #zip -r ${destinationDir}/Dentist-${versionString}-${shownName}-${newFileDateName}${buildNumberSuffix}.dSYM.zip ${destinationDir}/Dentist-${configurationName}.app.dSYM
        zip -r ${destinationDir}/Dentist-${versionString}-${shownName}-${newFileDateName}${buildNumberSuffix}.dSYM.zip ${destinationDir}/Dentist-${configurationName}.app.dSYM
        rm -rf ${destinationDir}/Dentist-${configurationName}.app.dSYM
    fi
    
    #需要生成xcarchive包时打开下面代码
    #xcodebuild -workspace $workspaceName -scheme $schemeName -destination generic/platform=iOS archive -archivePath $destinationDir/$schemeName-${configurationName}.xcarchive -sdk iphoneos

    if [ "distribute" = ${lowercaseModeArg} ]; then
         if [ -d "${buildDir}/Build/Products/${configurationName}-iphoneos/Dentist.app" ]; then
             # Distribute模式生成app压缩包
             mv ${buildDir}/Build/Products/${configurationName}-iphoneos/Dentist.app ${destinationDir}/Dentist-${versionString}-${configurationName}.app
			 #zip -r ${destinationDir}/Dentist-${versionString}-${shownName}-${newFileDateName}${buildNumberSuffix}.app.zip ${destinationDir}/Dentist-${versionString}-${configurationName}.app
	         zip -r ${destinationDir}/Dentist-${versionString}-${shownName}-${newFileDateName}${buildNumberSuffix}.app.zip ${destinationDir}/Dentist-${versionString}-${configurationName}.app
	         rm -rf ${destinationDir}/Dentist-${versionString}-${configurationName}.app
         fi
    fi

    if [ -f ${destinationDir}/Dentist-${configurationName}.ipa ]; then
        #mv ${destinationDir}/Dentist-${configurationName}.ipa ${destinationDir}/Dentist-${versionString}-${shownName}-${newFileDateName}${buildNumberSuffix}.ipa
        mv ${destinationDir}/Dentist-${configurationName}.ipa ${destinationDir}/Dentist-${versionString}-${shownName}.ipa
    fi
    
    #需要生成xcarchive包时打开下面代码
    #if [ -d ${destinationDir}/$schemeName-${configurationName}.xcarchive ]; then
	#    #zip -r ${destinationDir}/$schemeName-${versionString}-${shownName}-${newFileDateName}${buildNumberSuffix}.xcarchive.zip ${destinationDir}/$schemeName-${configurationName}.xcarchive
    #    zip -r ${destinationDir}/$schemeName-${versionString}-${shownName}${buildNumberSuffix}.xcarchive.zip ${destinationDir}/$schemeName-${configurationName}.xcarchive
    #    rm -rf ${destinationDir}/$schemeName-${configurationName}.xcarchive
    #fi

	#还原Info.plist文件
	mv ./Student/Supporting\ Files/Info.plist.backup ./Student/Supporting\ Files/Info.plist
}

function createPackages()
{
    rm -rf $destinationDir
    mkdir -p $destinationDir
    cd ../

    #注意：这里是遍历函数的参数个数,不是外面调用shell的函数个数
    for modeName do
        rm -rf ./build
        mkdir -p ./build
        createPackage ${modeName}
    done

    return 0
}

function showPackagesType()
{
     echo ""
     echo "支持的打包选项列表:"
     echo "1. Debug包"
	 echo "2. Release(Adhoc)包"
     echo "3. AppStore发布包"
     echo "4. 所有的包(上面的1、2、3)"
     echo "q. 退出"
     echo ""
     echo "请输入选项编号(1/2/3/4/q):\c"
}

function main()
{
    count=0
	
    showPackagesType
    read inputStr

    while [[ $count -lt 5 ]]
    do
        case "${inputStr}" in
            "1")
                createPackages Debug
                return
            ;;
            "2")
                createPackages Release
                return
            ;;
            "3")
                createPackages Distribute
                return
            ;;
            "4")
                createPackages Debug Release Distribute
                return
            ;;
            "q")
                return 1 
            ;;
            *)
                ((count+=1))
                echo "您的输入不正确，请重新输入:\c"
                read inputStr
                continue
            ;;
        esac
    done

    echo "You are too stupid"
    return 1
}


#获取工程的版本号
echo "请输入版本号:\c"
read versionString

##修改Debug模式的Build Active Architecture Only为NO
##               Debug Information Format为DWARF with dSYM File
##               Strip Debug Symbols During Copy为YES
#if [ ! -f ../Dentist.xcodeproj/project.pbxproj.backup ]; then
#	sed -i.backup -e 's/\(.*\)ONLY_ACTIVE_ARCH = YES;/\1ONLY_ACTIVE_ARCH = NO;/g' -e 's/\(.*\)COPY_PHASE_STRIP = NO;/\1COPY_PHASE_STRIP = YES;/g' -e 's/\(.*\)DEBUG_INFORMATION_FORMAT = dwarf;/\1DEBUG_INFORMATION_FORMAT = \"dwarf-with-dsym\";/g' ../Dentist.xcodeproj/project.pbxproj
#fi
#if [ ! -f ../Pods/Pods.xcodeproj/project.pbxproj.backup ]; then
#    sed -i.backup -e 's/\(.*\)ONLY_ACTIVE_ARCH = YES;/\1ONLY_ACTIVE_ARCH = NO;/g' -e 's/\(.*\)COPY_PHASE_STRIP = NO;/\1COPY_PHASE_STRIP = YES;/g' -e 's/\(.*\)DEBUG_INFORMATION_FORMAT = dwarf;/\1DEBUG_INFORMATION_FORMAT = \"dwarf-with-dsym\";/g' ../Pods/Pods.xcodeproj/project.pbxproj
#fi
#if [ ! -f ../DentistCommon/DentistCommon.xcodeproj/project.pbxproj.backup ]; then
#    sed -i.backup -e 's/\(.*\)ONLY_ACTIVE_ARCH = YES;/\1ONLY_ACTIVE_ARCH = NO;/g' -e 's/\(.*\)COPY_PHASE_STRIP = NO;/\1COPY_PHASE_STRIP = YES;/g' -e 's/\(.*\)DEBUG_INFORMATION_FORMAT = dwarf;/\1DEBUG_INFORMATION_FORMAT = \"dwarf-with-dsym\";/g' ../DentistCommon/DentistCommon.xcodeproj/project.pbxproj
#fi


main
ret=$?
cd ${binDir}


##还原Debug模式的Build Active Architecture Only配置
#mv ../Dentist.xcodeproj/project.pbxproj.backup ../Dentist.xcodeproj/project.pbxproj
#mv ../Pods/Pods.xcodeproj/project.pbxproj.backup ../Pods/Pods.xcodeproj/project.pbxproj
#mv ../DentistCommon/DentistCommon.xcodeproj/project.pbxproj.backup ../DentistCommon/DentistCommon.xcodeproj/project.pbxproj

if [ ${ret} -eq 0 ]; then
   	open ${destinationDir}
fi

if [ ${buildCmdReturn} -ne 0 ]; then
    exit 1
else
    exit 0
fi


