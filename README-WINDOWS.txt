On Windows, if you don't have Ruby installed (if you don't know, then chances are you don't), you'll need to install it. 

Get the RubyInstaller for Windows here: (I used version 1.9.2 p290)
http://rubyinstaller.org/downloads/

Run the installer once it finishes downloading.

Download the splashid-to-strip.zip project and extract the contents into a folder named SplashID on your Desktop:

Save your SplashID Export.vid file to this folder as well.

Now let's fire up the Console with Ruby:

Start -> All Programs -> Ruby1.9.2-p290 -> Start Command Prompt With Ruby. It should look about like this:

    ruby 1.9.2p290 (2011-07-09) [i386-mingw32]
    
    C:\Users\William Gray>
    
Let's navigate to the directory with your files. Then, run this command:

    ruby convert.rb

That last command converts your file to strip-import.csv, output should look like:

    C:\Users\William Gray\Desktop\SplashID>ruby convert.rb
    Examining SplashID Export.vid...
    We've found 11 entries, composing output...
    Your file strip-import.csv is ready for import into STRIP!
