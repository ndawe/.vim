Noel's vim configuration and plugins.

See http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/

Install ctags::

    sudo apt-get install exuberant-ctags

Initialize the plugin submodules::

    git submodule init
    git submodule update

and::

    mkdir ~/.vimcrud
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc

To update to the latest version of each plugin bundle, run the following::
    
    git submodule foreach git clean -fdx
    git submodule foreach git fetch origin master
    git submodule foreach git reset --hard origin/master
