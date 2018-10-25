tell application "Finder"
	set dialogText to " Packages 📦 Signed 📝"
	set thePackages to every item of (choose file with prompt "Please select packages to sign:" of type {"pkg", "dmg"} with multiple selections allowed) as list
	set currentUser to do shell script "whoami"
	set identitySearch to do shell script "security find-identity -v | grep Installer"
	set identityFound to (second word of first paragraph of identitySearch)
	set dt to "/Users/" & currentUser & "/Desktop/"
	set theImageCount to length of thePackages
end tell
set progress total steps to theImageCount
set progress completed steps to 0
set progress description to "Signing Packages..."
set progress additional description to "Preparing to sign."
repeat with index from 1 to the count of thePackages
	set currentPackage to item index of thePackages
	set unsignedPath to POSIX path of currentPackage
	set quotedUnsignedPath to quoted form of unsignedPath
	set unsignedPackage to name of (info for currentPackage)
	set progress additional description to "Signing Package " & unsignedPackage & " " & index & " of " & theImageCount
	set quotedsignedPath to quoted form of (dt & unsignedPackage)
	set theCommand to "productsign --sign " & identityFound & " " & quotedUnsignedPath & " " & quotedsignedPath & ""
	do shell script "" & theCommand & ""
	set progress completed steps to index
	delay 1
end repeat
set progress total steps to 0
set progress completed steps to 0
set progress description to ""
set progress additional description to ""
display dialog ((count of thePackages) & dialogText) as text with title "Signing Completed" buttons {"Close"} default button "Close" with icon path to resource "cert.icns" in bundle (path to me)
