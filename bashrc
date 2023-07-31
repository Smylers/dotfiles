# .bashrc
#
# Smylers's 'Bash' start-up script
# 
# complete configuration; deals with interactive and non-interactive shells;
# should be invoked from .bash_profile


# TODO  Use Aaron's test for being a UTF-8 terminal to set the appropriate
# language thingies, making sure this propagates to Mutt.

# TODO  See /etc/bashrc about whether to be allow 8-bit characters or Meta
# keystrokes; consider scriptily putting Meta equivalents to have the best of
# both.

# TODO  locate that assumes -i (unless already given) if no upper-case chars

# TODO  zip -r
# TODO  mvb ("move back") that does mv but with last two args swapped over, so
# that mv Up b Enter can be used to undo a mv
# TODO  Put $LOGNAME (or whatever) into remote $CVSROOT things, so that will
# work under sudo without requiring root on the repository server
# TODO  Have a mv variant (deploy?) that does cp then rm, so that the
# permissions of the previous file remain.
# TODO  On every directory change set $dir to be like $PWD but with ~/ stuff at
# the beginning of it when under my home dir (and other people's?).
# TODO  Keystrokes to jump to CVS conflict markers.

# TODO  Either unalias -a, or specifically (and quietly) unalias each function
# I'm creating (such as for ll, below).

export GTK_OVERLAY_SCROLLING=1

# * Paths

# Have my stuff come first in the path; also include sbin/ directories:
PATH=~/bin:/usr/local/sbin:/usr/local/bin:/snap/bin:/sbin:/bin:/usr/sbin:/usr/bin
PATH=$PATH:/usr/X11R6/bin:/usr/games
# (Prepending ~/bin: on to $PATH seems to produce multiple occurances of
# /home/smylers: at the start of it in terminals, presumably because several
# processes have each sourced this file and added another one on, so I've set
# it absolutely instead.)

# TODO  Remove the sbin-s from the above, have them just set when using sudo,
# (and for sudo's Bash completion).

# Propagate to systemd units:
systemctl --user import-environment PATH

# Enable personal manpage directory, by resetting to the default then
# prepending my directory on that:
unset MANPATH
export MANPATH=~/share/man:$(manpath)
# (Just doing the second of those results in multiple occurances of ~/man in
# nested shells.)

# When changing directories, first check for paths relative to the current
# directory, then the parent and grandparent directories, then the home
# directory:
export CDPATH=".:..:../..:~:~/pending"
# This has the bizarre side-effect of making nearly all directory changes be
# emitted on the terminal.  It makes sense to emit changes to directories
# that aren't relative to the current directory, so cd emits the new
# directory when $CDPATH is used.  However because . is at the start of
# $CDPATH even simple child directory changes are displayed.  Omitting . from
# $CDPATH makes $CDPATH directories take precedence over the current
# directory, which can produce very unexpected behaviour.  ('TC Shell' avoids
# the problem by checking for the current directory before $CDPATH, though
# theoretically that is less flexible.)
# 
# TODO  Getting round this would seem to involve writing cd as a function.
# That could unset CDPATH, try cd with the specified parameters, then only
# set CDPATH and try again if the 'bare' cd failed.
# TODO  cd as a function could also check for its argument being a file
# instead of a directory, and if so uses the directory containing that file.
# Also for pushd.

# When changing directory through a symlink use the target for the current
# directory:
set -o physical
# TODO  Consider not doing that, but in the case where pwd gives different
# results for the two, printing out the physical one.  Also have a command
# such as cdp to move to the physical version.

# Automatically fix minor spelling errors in arguments to cd and paths:
shopt -s cdspell
shopt -s dirspell 2> /dev/null

# If a program moves then look for it:
shopt -s checkhash


# * Locale

# Mostly assume UK English settings (if possible); $LANG is the default locale
# for any individual LC_* variable that hasn't been set; if multiple UK locales
# are available the reverse sort should prefer the UTF8 one; fall back to C if
# there aren't any:
export LANG=$(locale -a | (grep ^en_GB || echo C) | sort -r | head -n 1)

# Some programs, notably units, use $LOCALE for the locale:
export LOCALE=$LANG

# Prevent [A-Z] including lower-case chars:
export LC_COLLATE=C

# See also the ls function below.

# Convert old VT100 line-drawing characters into actual UTF-8 characters.
# Needed for using Mutt in Putty:
export NCURSES_NO_UTF8_ACS=1


# * Defaults

umask ug=rwx,o=rx
export TMP=~/tmp/
export TMPDIR=$TMP
export PERL_CPANM_OPT='--sudo --prompt'

PERLBREW_ROOT=~/lib/perlbrew
if [ -d $PERLBREW_ROOT ]
then
  export PERLBREW_ROOT
  source $PERLBREW_ROOT/etc/bashrc
else
  unset PERLBREW_ROOT
fi

# Default to less being unobtrusive -- being undetectable if there's only one
# screen, leaving output in the main terminal, and being quittable just by
# scrolling beyond the end of the output -- as well as not beeping, leaving
# long lines alone, treating all-lower-case searches as being case-insensitive,
# and allowing coloured output through (from tools such as git-diff):
export PAGER=less
export LESS=-FXeqSiR

# But still have manpages switching to the alternate output, so they don't
# clobber normal output; this requires them not being too eager to exit:
export MANPAGER='less -+F -+X -+e'

export CVS_RSH=ssh
export DEBFULLNAME=Smylers
export DEBEMAIL=smylers@donhost.co.uk

export MOSH_TITLE_NOPREFIX=
export MOSH_PREDICTION_DISPLAY=always

export SVKDIFF='diff -ub'

# Have zip be recursive, and ignore Vim swap files:
export ZIPOPT='-r -x .*.sw? */.*.sw? @'

if which vim > /dev/null
then
  export EDITOR=vim
fi

# Get the short hostname, which is needed in a couple of places below.  The
# hostname command mostly returns the short hostname, but sometimes (especially
# on BSD) it returns the fully qualified name.  hostname -s should be the short
# version, but on at least one server it merely gives an error (and takes a
# while doing so).  hostname without arguments always seems to work, so use
# that and manually strip any trailing parts afterwards:
hostname=$(hostname)
hostname=${hostname%%.*}

# An extended glob is used below, so ensure this is on.  The glob is inside the
# following then block, but it seems that this needs setting before any of the
# block is parsed:
shopt -s extglob

# Only mess with some things if running interactively:
if [ "$PS1" ]
then
  # (Aaron reckons checking $PS1 is a kludge and that the 'proper' thing to do
  # is to check for "i" being in the set options.  However this seems to
  # involve doing something along the lines of:
  # 
  #   if [ "${-//[^i]}" ]
  #   
  # That seems like too much effort to me, since 'bash(1)' explicitly states
  # that $PS1 can be tested like this (and the default .bashrc does that).)


  # * Prompt

  # Notice when the window changes size, with the hope of keeping the prompt
  # sane afterwards:
  shopt -s checkwinsize

  # non-ascii characters used below:
  esc=$'\033'
  bel=$'\007'
  ldaq=$'\302\253' # left double-angled quote
  rdaq=$'\302\273' # right ditto
  # TODO  See if it makes sense to either include those \302s or not depending
  # on whether $LANG contains "UTF8".  Or whether there's an iconv thing or
  # whatever which just does the right thing.

  # but starting umpteen subshells for it in every
  # prompt is far too slow.
  # formatting escape sequences used below; tput is _supposed_ to be the
  # least-hassle way of specifying formatting across different systems, but
  # these codes only work for terminfo systems, not termcap systems such as
  # FreeBSD, so check for this and use escape sequences otherwise; the
  # variables would've been used anyway -- apart from readablility, not
  # starting umpteen subshells for tput in every prompt saves considerable
  # time:
  if [ -d /etc/terminfo ]
  then
    reset=$(tput sgr0)

    # colour scheme optimized for Linux terminals (which do brightening instead
    # of emboldening and have different colours):
    if [ $TERM == linux ]
    then
      cyan=$(tput setaf 6)
      grey=$(tput setaf 0; tput bold)
      blue=$(tput setaf 4) # bright continues throughout prompt
      green=$(tput setaf 2)
      red=$(tput setaf 1)
      bold=$(tput setaf 7)

    # colour scheme used everywhere else:
    else
      cyan=$(tput setaf 6)
      grey=$(tput setaf 7)
      blue=$(tput setaf 4)
      green=$(tput setaf 2)
      red=$(tput setaf 1)
      bold=$(tput setaf 0; tput bold)
    fi
    # (Yes those variable names don't quite make sense.  But the two themes are
    # similar to each other and the prompt definition below is much more
    # readable with "$grey" than "$calendar_colour".)

  # termcap:
  else
    reset=$esc"[0m"

    cyan=$esc"[36m"
    grey=$esc"[37m"
    blue=$esc"[34m"
    red=$esc"[31m"
    bold=$esc"[0;1m"
  fi

  # Make a guess as to whether this is a local shell or a remote connection to
  # another computer:
  remote=''
  if [ "$SSH_CLIENT$REMOTE_HOST" ]
  then
    remote=true
  fi

  # COLUMNS is only set after the first prompt has been displayed when logging
  # in to a Linux terminal, which causes problems with its use below.  So set
  # it here to a default value which will get overridden for the second prompt
  # onwards in Linux terminals and (hopefully) before the first prompt
  # elsewhere:
  COLUMNS=80

  # Use customizable completion; this file will source my local customizations:
  file=/etc/bash_completion
  if [ ! -e $file ]
  then
    file=/usr/local$file
  fi
  source $file
  # Above now needed for __git_ps0, so moved up

  if declare -F __git_ps1 > /dev/null
  then
    # Set up a variable rotating through two values in consecutive prompts:
    #prompt_rotation=0
    # (Finding the modulus of \#, the command number, isn't quite good enough
    # because empty comands don't count and therefore Enter on its own doesn't
    # rotate to the next prompt.  The variable can't be set in PS1 because that
    # would be done in a subshell and not propagate.

    # TODO Consider if the date/time is useful, and if so put it back in.

    bat=''
    if compgen -G '/sys/class/power_supply/BAT?/capacity' > /dev/null
    then
      bat='"\["'$green'"\]"$(printf "\u$((2581+$(</sys/class/power_supply/BAT?/capacity)*8/101))")'
    fi

    uh=''
    if [[ $USER != @(smy?(l)ers|simon?(.m)|root) ]]
    then
      uh=$USER@$hostname:
    elif [ "$remote" ]
    then
      uh=$hostname:
    fi

    if echo -e "4.3\n$BASH_VERSION" | sort -VC
    then
      d_set='d="${PWD/#$HOME/\~}"'
    else
      d_set='d="${PWD/#$HOME/~}"'
    fi
    if [[ $TERM == xterm* ]]
    then
      d_set="$d_set; "'echo -ne "'$esc']0;'"$uh"'$d'"$bel"'"'
    fi
    GIT_PS1_SHOWCOLORHINTS=1
   #PROMPT_COMMAND=$d_set';                  if [[ $j ]]; then j="\['$red'\]'$ldaq'$(wc -l <<<$j)'$rdaq '"; fi; __git_ps1 '"\[$reset\]\[$grey\]"'$(if ((prompt_rotation = 1 - prompt_rotation)); then date +%b%e; else echo \A; fi)'"\[$blue\] $uh\w" "$j\['$bold'\]\$\[$reset\] " "|%s"'
    PROMPT_COMMAND="$d_set; "'j=$(jobs -sp); if [[ $j ]]; then j="\['$red'\]«$(wc -l <<<$j)» "; fi; __git_ps1 '$bat'"\['$blue'\]'$uh'\w\['$grey'\]" " $j\['$bold'\]\$\['$reset'\] " "|%s"'

    # TODO Split that into sensible lines

    # TODO Work out if it's better to put the \[ and \] in the named variables.

    # TODO Git branch a different colour or with a star or something if changes

    # TODO Battery status. Maybe as a ‘chart’, with different block characters?

    # TODO a line-break if there would be fewer than twenty characters left on
    # this line, otherwise a space? Too awkward, now Git is handling this

    # TODO Refactor the ‘else’ to work, even only simply, with minimal
    # duplication.
  else
    # Set up a variable rotating through two values in consecutive prompts:
    prompt_rotation=0
    PROMPT_COMMAND='prompt_rotation=$((1 - $prompt_rotation))'
    # (Finding the modulus of \#, the command number, isn't quite good enough
    # because empty comands don't count and therefore Enter on its own doesn't
    # rotate to the next prompt.  The variable can't be set in PS1 because that
    # would be done in a subshell and not propagate.)

    # Include a battery status indicator if appropriate.  Use the letters to
    # indicate charge from 'a' (0%-3%) to 'y' (96%-99%), 'z' (100%), with
    # upper-case if AC power is connected:
    if apm=$(apm -s 2> /dev/null) && [ $apm = 1 ]
    then
      battery="\[$cyan\]"'$(apm | perl -pe '\''/^AC o(?:(n)|ff)-line.*: (\\d+)%$/; $_ = chr((ord "z") - int($2 / 4)); $_ = uc if $1'\'') '
    fi
    # TODO  If battery is set (in this file) then it will always take up 2 chars
    # in the display, so the line-break thing below can have its constant changed
    # at compile-time.

    # Put the username (and an at-sign) into $uh only if the user isn't my normal
    # username or root (which is identified with a hash sign at the end).  Put
    # this computer's hostname (and a colon) into $uh when being another user;
    # otherwise include it only if this appears to be a remote login being viewed
    # on another computer through SSH or telnet.  This allows $uh to be used
    # instead of \u\h in the prompt, with the benefits of not taking up any space
    # for typical shells on the local computer and increasing the chance of
    # uniqueness of the start of terminal window titles:
    uh=''
    if [[ $USER != @(smy?(l)ers|simon?(.m)|root) ]]
    then
      uh=$USER@$hostname:
    elif [ "$remote" ]
    then
      uh=$hostname:
    fi

    # the prompt, starting with grey for the calendar:
    PS1="\[$reset\]$battery\[$grey\]"

    # alternating date ("Jun23") and time ("20:30"):
    PS1=$PS1'$(if [ $prompt_rotation == 0 ]; then date +%b%e; else echo \A; fi)'
    # TODO  Work out why this gives a syntax error on using Ctrl+D to log out.

    # blue path (with hostname for remote logins):
    PS1=$PS1"\[$blue\] $uh\w"

    # Current Git branch if any, in green with a grey line separating it from the
    # path:
    PS1="$PS1"'$(b=$(git name-rev HEAD 2> /dev/null | cut -c 6-); '
    PS1="$PS1"'if [ $b ]; then echo "\['$grey'\]|\['$green'\]$b"; b="|$b"; fi)'

    # if any stopped jobs, the number of them in angled brackets in $j, for
    # displaying just before the final dollar but calculated now for line-break
    # purposes:
    PS1=$PS1'$(j=$(jobs -s); if [ "$j" ]; then '
    PS1=$PS1"j=$ldaq"'$(($(echo "$j" | grep "^\\[" | wc -l)))'"$rdaq' '; fi; "
    # (\j isn't good enough, because that includes all jobs.  There being no
    # stopped jobs can be determined with just built-in commands, and wc is only
    # used if it is needed.  That ridiculous cacophony of parentheses is to treat
    # the output of wc as a number, so as to trim spaces from it without
    # resorting to sed.)

    # a line-break if there would be fewer than twenty characters left on this
    # line, otherwise a space:
    PS1=$PS1'w="\w"; if [ $(($COLUMNS - '
    PS1=$PS1'('$((${#uh} + 9))' + ${#w} + ${#b} + ${#j}) % $COLUMNS)) -lt 20 ]; '
    PS1=$PS1'then echo; else echo -n " "; fi; '
    # (The length of the computer name (if used) plus the fixed-width parts of
    # the prompt are summed now.  In each prompt this is added to the lengths of
    # \w (which is copied to $w for the purpose of discovering its length) and
    # $j, then the modulous of that with the column width (in case the line has
    # already wrapped) is subtracted from the column width to discover the number
    # of characters left on this line.  'Bash' removes trailing line-breaks from
    # command substitution, so the sustitution continues to the final dollar to
    # ensure that if a line-break was used there's something emitted after it.)
    # TODO  That doesn't always work.  Discover why not.

    # red stopped jobs count (if applicable) and bold dollar (or hash):
    PS1=$PS1'echo "\['$red'\]$j\['$bold'\]\$")'

    # finally a space:
    PS1=$PS1"\[$reset\] "

    # If in an 'X Term' or similar, also put the path (and hostname if remote) in
    # its title.  Emitting the control characters in PS1 used to work, in Bash
    # 3.0, but with Bash 3.1 when running in a Gnome Terminal this makes typing
    # unbearable sluggish (with the cursor flashing back to the beginning of the

    # line on _every_ keystroke), so instead put this in PROMPT_COMMAND.
    # 
    # \w isn't available in PROMPT_COMMAND, but I want PROMPT_COMMAND to create
    # $d with that path for user use, so $d can also be used in the terminal
    # title.
    #
    # Bash 4.3 interprets ~ in the replacement of // as the input; a \ seems to
    # prevent this. But in Bash 4.1, the ~ is literal, and a \ also shows up
    # literally:
    if echo -e "4.3\n$BASH_VERSION" | sort -VC
    then
      d_set='d="${PWD/#$HOME/\~}"'
    else
      d_set='d="${PWD/#$HOME/~}"'
    fi
    # TODO Check if $DIRSTACK would work here instead.

    # Put this at the start of PROMPT_COMMAND, since, unlike the other things in
    # PROMPT_COMMAND it is user-visible, but only include the title-setting part
    # if this is a suitable terminal:
    if [[ $TERM == xterm* ]]
    then

      # The command itself as it ends up in PROMPT_COMMAND should use
      # double-quotes round its parameter, so let's use single quotes in this
      # file around those.  This necessitates breaking off the single quotes to
      # interpolate a variable set in this file (but not for $d, whose name
      # rather than value should be embedded in the command):
      d_set="$d_set; "'echo -ne "'$esc']0;'"$uh"'$d'"$bel"'"'
    fi
    PROMPT_COMMAND="$d_set; $PROMPT_COMMAND"
    # (That can't be done in PROMPT_COMMAND because \w isn't available there.)
  fi

  # variables no longer needed:
  unset esc bel ldaq rdaq reset grey blue green red bold uh battery d_set


  # * History

  # Remember the past 2000 commands:
  export HISTSIZE=2000
  export HISTFILESIZE=$HISTSIZE
  # TODO  Have the cron job for making a complete list of all commands ever.

  # Add to the history file rather than overwriting it, so the last shell to
  # exit doesn't clobber the history of other shells:
  shopt -s histappend

  # Write out the history of each command just before displaying the prompt for
  # the following command, so that shells opened after the current shell have
  # up-to-date history:
  PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

  # Record dates in the history list:
  export HISTTIMEFORMAT='%Y %b %e %H:%M  '

  # Don't add a command to the history if duplicates the preceeding command
  # exactly or if it starts with a space:
  export HISTIGNORE='&: *'

  # Store all lines of a multi-line command in a single history entry:
  shopt -s cmdhist
  shopt -s lithist

  # If a history subsitution fails, supply the failed attempt for editing:
  shopt -s histreedit


  # * Keystrokes
  
  # Fail if a glob doesn't match, rather than passing it unquoted to commands.
  # failglob provides this behaviour, but it's a relatively new feature so
  # can't be relied on.  The docs say it was introduced in 'Bash 3.0', but some
  # installations of 2.05b.0(1)-release have it (and some don't) -- so simply
  # try setting it, and ignore any errors if it fails.  Also set nullglob,
  # which if failglob isn't available is better than nothing:
  shopt -s nullglob
  shopt -s failglob 2> /dev/null

  # Recursive globbing with **:
  shopt -s globstar 2> /dev/null

  # Don't have a single Ctrl+D exit a shell, but do exit if it's pressed twice
  # in a row:
  export IGNOREEOF=1

  # Most keystrokes are defined in .inputrc.


  # * Variables
  # 
  # Variables made available for use on the command line.

  export d
  # The current directory, but with the home directory as ~/ rather than a full
  # path.  This is useful so that on computers where the username or home
  # directory is different there is a path which resolves to the equivalent
  # place on each one, for example in scp commands.


  export NNTPSERVER=lnntp.comp.leeds.ac.uk


  # * Functions
  # 
  # Functions that override default commands (generally invoking them with
  # certain options) are only set in interactive shells, to prevent


  function mkdir
  # runs mkdir, defaulting to making any intermediate directories that are
  # required
  {
    command mkdir -p "$@"
  }

  if [ "$COLORTERM" = gnome-terminal -a ! "$remote" ]
  then
  # TODO  Rationalize the remote testing with where it's already done for the
  # prompt.
    function fork
    # forks another 'Gnome Terminal' with the main terminal class and
    # propagating the current directory
    {
      gnome-terminal --tclass main &
    }
  fi

  if [ "$TERM" == xterm ]
  then
    function psql
    # sets the terminal title
    {
      title=Postgres
      if [ "$*" ]
      then
        title="$title: ${!#}"
      fi
      term-title "$title"
      command psql "$@"
    }
    # TODO  Same thing for mysql
    # TODO  Setting PAGER for mysql
  fi

  # This is an interactive shell, so have auto_fork-linked applications return
  # to the prompt immediately without needing to type a &:
  export AUTO_FORK=1

  unset remote

  if [ $TERM == screen ]
  then
    echo '[screen is running]'
  fi

# In a non-interactive shell don't let auto_fork break expectations; reset the
# flag in case this was invoked from an interactive shell further up:
else
  export AUTO_FORK=0


fi


function ..
# cd to the parent directory
{ 
  cd ..
}

function ...
# cd to the grandparent directory
{ 
  cd ../..
}

function ....
# cd to the great-grandparent directory
{ 
  cd ../../..
}


function -
# cd to the previous direction
{
  cd -
}


function nd
# new directory — create, and change into it
{
  mkdir -p "$@" && cd "$1"
}


function j
# jobs but shorter to type and with the process IDs displayed
{
  jobs -l "$@"
  # TODO  Work out what's up with this and piping.  It seems that piping from
  # jobs never gives any output when its definied as a function (but saving
  # the output to a variable and piping that is fine).  See Bash-Prompt-HOWTO
  # for comment on jobs not working thorugh a pipe in a previous version of
  # 'Bash'.
}
export -f j


function d
# dirs but with the directory stack displayed on separate lines and with
# positions listed
{
  dirs -v "$@"
}
export -f d


function pu
# pushd but with the stack listed vertically and a single digit treated as a
# stack entry rather than a directory name; something like ./3 can be used if
# necessary
{
  if [[ $# == 1 && $1 == [1-9] ]]
  then
    set -- +$1
  fi
  pushd "$@" > /dev/null && d
}
export -f pu

function po
# popd but with the stack listed vertically and a single digit treated as a
# stack entry rather than a directory name; something like ./3 can be used if
# necessary
{
  if [[ $# == 1 && $1 == [1-9] ]]
  then
    set -- +$1
  fi
  popd "$@" > /dev/null && d
}
export -f po
# TODO  Factor out the repetition in the above 2 function definitions.


function duff
# produces a unified diff
{
  colordiff -ur "$@"
  # TODO  Add in more flags.  -r may as well always be there, consider -p for
  # .c programs and -F with regexes for other things.  See this page for
  # suggestions:
  # 
  #   http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2002-08/msg01173.html
}
export -f duff


function gduff
# opens a Vim window with a diff
{
  gvimdiff -c 'windo setlocal foldcolumn=0' "$@"
}
export -f gduff


function paged
# run the specified command, paging its output if this is interactive
{

  # To page the output we need a pager, and for both stdin and stdout to be
  # connected to a terminal:
  if [[ -n "$PAGER" && -t 0 && -t 1 ]]
  then

    # Use command to ignore shell functions, so that a shell function can be
    # used to wrap a command of the same name to invoke paged:
    command "$@" | "$PAGER"

  # Otherwise try to be transparent:
  else
    command "$@"
  fi

}
export -f paged

# Wrap these commands with functions that invoke paged:
for cmd in dict env grep help locate look type whois
do
  if type $cmd &> /dev/null
  then
    eval 'function '$cmd' { paged '$cmd' "$@"; }'
    export -f $cmd
  fi
done

# TODO  Page cvs (and svn, svk) for most commands, but not commit


function ls
# runs ls, appending indicators to filenames and ordering filenames for the
# current locale, paging if appropriate
{
  # Having $LC_COLLATE set to en_GB (and at least many other languages) makes
  # the range [A-Z] include most lower-case characters.  That isn't desired,
  # so mostly I have $LC_COLLATE as C.  However, it's nice to have directory
  # listings in alphabetical order rather than with all the capital letters
  # before all the lower-case letters.  Therefore set $LC_COLLATE to the
  # current locale for just this command.
  # 
  # In general the -v flag to ls is useful.  It means that, for example,
  # page10.html comes after page9.html rather than between page1.html and
  # page2.html.  However -v seems to ignore the locale, and since I have more
  # directories containing mixed-case filenames than with numbers in them
  # I've left this out.  TODO  Report this as a bug, then include -v once
  # it's fixed.
  # 
  # This function isn't exported, since there may be programs relying on the
  # output of ls being in a particular format (and not having indicators on
  # the end of filenames).
  # 
  # TODO  Don't use -F if -Q (or similar) has been specified.

  # Only add the indicators if the output is to a terminal, so as not to mess
  # up any programs processing its output as input:
  if [[ -t 1 ]]
  then

    # Page like with the paged function above, but if paging adding the -C flag
    # to restore the default of display with columns which is otherwise lost by
    # piping:
    if [[ -n "$PAGER" && -t 0 ]]
    then
      LC_COLLATE=$LANG command ls -CF "$@" | "$PAGER"

    # Terminal output but not paging:
    else
      LC_COLLATE=$LANG command ls -F "$@"
    fi

  # Non-terminal output:
  else
    LC_COLLATE=$LANG command ls "$@"
  fi

}

function simonsays
# really do it
{
  sudo "$@"
}
export -f simonsays


function rr
# redo as root — repeat the previous command with sudo; credit:
# https://twitter.com/liamosaur/status/506975850596536320
{
  cmd=$(fc -ln -1)
  cmd="sudo ${cmd#*	 }"
  echo "$cmd"

  # Append the sudo-ed command to this shell's history, so that the Up arrow
  # can be used to find it, rather than just the rr command. Weirdly this seems
  # to cause rr itself not to end up in the history, which is an unexpected
  # bonus:
  history -s "$cmd"

  # The quotes are needed to preserve any quotes in $cmd, and eval to parse
  # them:
  eval "$cmd"
}


# TODO  Have these, where possible, as being short shell scripts rather than
# functions.  It makes them easier to give to other people, and it means
# they'll still work under sudo, and the like.
unalias ll 2> /dev/null
function ll
# produces a long directory listing
{
  LC_COLLATE=$LANG command ls -Flh "$@"
  # TODO  Remove the repetition between here and the ls function, possibly by
  # making this function call that one (which will only work if ls is always
  # defined).
}
export -f ll


function doc
# changes to the doc directory of the specified package and lists the files
# there
{
  # TODO  Do a cd rather than a pu when already under /usr/share/doc/
  pu "/usr/share/doc/$1" && ls
  # TODO  Have tab completion for this.
}
export -f doc


function c
# re-runs the previous command and copies its output to the X selection, all on
# one line
{
  echo -n $(eval "$(fc -ln -1)") | xclip
}
export -f c



function fig2ps
# converts a 'XFig' file to a PostScript file with the same basename
{
  fig2dev -L ps "$1" "${1%.fig}.ps"
}
export -f fig2ps

function fig2eps
# converts a 'XFig' file to an EPS file with the same basename
{
  fig2dev -L eps "$1" "${1%.fig}.eps"
}
export -f fig2eps

# TODO  sudo bash then ll works, but sudo ll doesn't.  So make a wrapper for
# sudo that checks for the existence of a function and if so explicitly calls
# that, otherwise sudo-s normally?

# TODO  If that works, then make something for date that checks for -s and if
# so does a hwclock systohc afterwards.  In fact, even if the above doesn't
# work a -s in date could so a sudo anyway.

# TODO  Network-work-again-notify
# 
# until ping -c 1 davefisher.co.uk > /dev/null; do echo  -n .; sleep 1; done; while true; do echo -e 'Network reachable!\a'; sleep 1; done

# TODO  mysql --pager $PAGER, and with psql options too


# Bring in computer-specific configuration, so that different computers can
# have different http_proxy settings, for example, without having to fork this
# file.  Use the computer name in the filename so that all config files can be
# replicated everywhere without interfering with each other:
local_config_file=~/etc/bash/rc.$hostname
if [ -f $local_config_file ]
then
  source $local_config_file
fi
unset local_config_file hostname


function command_not_found_handle
# allows options to be added to the just-run command simply by entering the
# options; also checks for unrecognized commands being known hostnames, SSHing
# to them if so (after the normal Debian check for being an installable
# command)
{

  # If the command starts with a hyphen then treat it as an option for the
  # previous command, and rerun that:
  if [[ "$1" == -* ]]
  then

    # The current command becomes the option(s) to add to the previous one, but
    # stupidly if the user typed multiple words all but the first get ignored
    # when invoking this handler.  To allow for multiple options we need the
    # full command.  Fortunately history has already been updated such that the
    # most recent entry is the currently 'running' command:
    local opt=$(HISTTIMEFORMAT='' history 1)

    # The timestamp can be suppressed but there's still the history number and
    # two spaces at the start of the line, so remove them:
    opt=${opt#*  }

    # The previous command becomes the command.  history doesn't provide a
    # convenient way of getting the penultimate entry by itself, but
    # fortunately fc does (though fc hasn't been updated yet, so it's actually
    # the most recent entry):
    local cmd=$(fc -ln -1)

    # With fc the history number can be suppressed, but there's still a tab and
    # a space to be removed.  Also put a space at the very end of the line, to
    # ensure that even with single-word commands the first word is followed by
    # a space:
    cmd=${cmd#	 }' '

    # Stick the option(s), surrounded by spaces, after the first word:
    cmd=${cmd/ / $opt }

    # Remove the space we inserted at the end of the line:
    cmd=${cmd% }

    # Run the command:
    eval $cmd
    return
  fi

  # Otherwise, first do the normal Debian thing of seeing if the command is
  # available in a package which isn't installed, and if so tell the user what
  # to type to install it (but only if this support is installed):
  local installable_checker=/usr/lib/command-not-found
  if [[ -x $installable_checker ]]
  then

    # If this does find a command then we want to stop looking here.
    # Unfortunately the checker returns the same exit code either way, so the
    # only way of telling is to capture the output to a variable:
    local installable_msg
    installable_msg=$($installable_checker -- "$1" 2>&1)

    # If find something then we want to propagate the exit code, so capture
    # that too; note this is why installable_msg above is declared and set on
    # separate lines, otherwise we end up recording the success of the local
    # command rather than that of the subshell:
    local installable_exit_code=$?

    # If we got anything then display it and we're done:
    if [[ $installable_msg ]]
    then
      echo $installable_msg
      return $installable_exit_code
    fi
  fi

  # Otherwise see if the command is a known host (but only if the _known_hosts
  # function, defined for Bash completion, is available):
  if declare -F _known_hosts > /dev/null
  then

    # As it's a completion function _known_hosts has an awkward interface -- we
    # have to set up a fake command-line for it to 'complete':
    COMP_WORDS="$1"
    COMP_CWORD=0
    _known_hosts

    # If its first suggested 'completion' is what we supplied then it was a
    # hostname, so try SSHing to it:
    if [[ "${COMPREPLY[0]}" == "$1" ]]
    then
      if ssh $1
      then

        # bash(1) says that we should return 0 if the command is now available
        # for future use; well, it isn't, but we have successfully SSHed and
        # doing this same thing again will work, so let's count that as good
        # enough, so as to suppress the message about the command not being
        # found:
        return
      fi
      # Note that if the SSH fails its exit code gets lost, because the only
      # permitted failure code we can return is that below.

    fi
  fi

  # We're still here, so indicate nothing's been found:
  return 127
}
export -f command_not_found_handle


function aoc
# sets up today's Advent of Code directory
{
  cd "$(advent_of_code_dir)"
}

default_bindings=$(mktemp)
bind -p > $default_bindings
source /usr/share/doc/fzf/examples/key-bindings.bash

# Leave Ctrl+T and Alt+C alone:
bind -f $default_bindings
rm $default_bindings

# Use Alt+, for picking files:
bind -x '"\e,": "fzf-file-widget"'

# Complete after **. Debian moved the location of the file between versions; as
# message 30 on this bug points out, the new location doesn't actually help
# with anything: https://bugs.debian.org/973570
for f in /usr/share/{bash-completion/completions/fzf,doc/fzf/examples/completion.bash}
do
  if [ -f $f ]
  then
    source $f
    break
  fi
done
