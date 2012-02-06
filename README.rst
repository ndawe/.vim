Noel's vim configuration and plugins forked from Evan.

See http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/

Install ctags::

    sudo apt-get install exuberant-ctags

and::

    mkdir ~/.vimcrud
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc

To update to the latest version of each plugin bundle, run the following::

    git submodule foreach git pull origin master
