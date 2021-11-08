module sample

go 1.14

require (
	github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src v0.0.0
)

replace (
    github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src => ../src
)