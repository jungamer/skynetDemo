--dofile "./Path.lua"
buildoptions(" -Wno-deprecated -Wall ")
workspace "SkynetDemo"
    location "Generated"
    language "C"
    kind "SharedLib"
	configurations {"Debug", "Release"}
    filter{"configurations:Debug"}
        flags{"Symbols"}
    filter{"configurations:Release"}
        optimize "On"
    filter {}
    targetdir("../../base/luaclib/")
    SKYNET_PATH = "../../3rd/skynet/"
    SERVER_PATH = "../../"
    implibprefix ""

project "package"
    includedirs {
        SKYNET_PATH.."skynet-src",
    }
    files {
        SERVER_PATH.."base/lualib-src/service_package.c"
    }
    buildoptions("-O2", "-fPIC")

project "lsocket"
    includedirs {
        "/usr/bin/include"
    }
    files {
        SERVER_PATH.."base/lualib-src/lsocket.c"
    }
    buildoptions("-O2", "-fPIC")
