[main]

# Enables context sensitive auto-completion. If this is disabled the all
# possible completions will be listed.
smart_completion = True

# Display the completions in several columns. (More completions will be
# visible.)
wider_completion_menu = False

# Multi-line mode allows breaking up the sql statements into multiple lines. If
# this is set to True, then the end of the statements must have a semi-colon.
# If this is set to False then sql statements can't be split into multiple
# lines. End of line (return) is considered as the end of the statement.
multi_line = False

# If multi_line_mode is set to "psql", in multi-line mode, [Enter] will execute
# the current input if the input ends in a semicolon.
# If multi_line_mode is set to "safe", in multi-line mode, [Enter] will always
# insert a newline, and [Esc] [Enter] or [Alt]-[Enter] must be used to execute
# a command.
multi_line_mode = psql

# Destructive warning mode will alert you before executing a sql statement
# that may cause harm to the database such as "drop table", "drop database"
# or "shutdown".
destructive_warning = True

# Enables expand mode, which is similar to `\x` in psql.
expand = False

# Enables auto expand mode, which is similar to `\x auto` in psql.
auto_expand = False

# If set to True, table suggestions will include a table alias
generate_aliases = False

# log_file location.
# In Unix/Linux: ~/.config/pgcli/log
# In Windows: %USERPROFILE%\AppData\Local\dbcli\pgcli\log
# %USERPROFILE% is typically C:\Users\{username}
log_file = default

# keyword casing preference. Possible values "lower", "upper", "auto"
keyword_casing = auto

# casing_file location.
# In Unix/Linux: ~/.config/pgcli/casing
# In Windows: %USERPROFILE%\AppData\Local\dbcli\pgcli\casing
# %USERPROFILE% is typically C:\Users\{username}
casing_file = default

# If generate_casing_file is set to True and there is no file in the above
# location, one will be generated based on usage in SQL/PLPGSQL functions.
generate_casing_file = False

# Casing of column headers based on the casing_file described above
case_column_headers = True

# history_file location.
# In Unix/Linux: ~/.config/pgcli/history
# In Windows: %USERPROFILE%\AppData\Local\dbcli\pgcli\history
# %USERPROFILE% is typically C:\Users\{username}
history_file = default

# Default log level. Possible values: "CRITICAL", "ERROR", "WARNING", "INFO"
# and "DEBUG". "NONE" disables logging.
log_level = CRITICAL

# Order of columns when expanding * to column list
# Possible values: "table_order" and "alphabetic"
asterisk_column_order = table_order

# Whether to qualify with table alias/name when suggesting columns
# Possible values: "always", never" and "if_more_than_one_table"
qualify_columns = never

# When no schema is entered, only suggest objects in search_path
search_path_filter = False

# Default pager.
# By default 'PAGER' environment variable is used
# pager = less -SRXF

# Timing of sql statments and table rendering.
timing = True

# Table format. Possible values: psql, plain, simple, grid, fancy_grid, pipe,
# ascii, double, github, orgtbl, rst, mediawiki, html, latex, latex_booktabs,
# textile, moinmoin, jira, vertical, tsv, csv.
# Recommended: psql, fancy_grid and grid.
table_format = psql_unicode

# Syntax Style. Possible values: manni, igor, xcode, vim, autumn, vs, rrt,
# native, perldoc, borland, tango, emacs, friendly, monokai, paraiso-dark,
# colorful, murphy, bw, pastie, paraiso-light, trac, default, fruity
syntax_style = tango

# Keybindings:
# When Vi mode is enabled you can use modal editing features offered by Vi in the REPL.
# When Vi mode is disabled emacs keybindings such as Ctrl-A for home and Ctrl-E
# for end are available in the REPL.
vi = False

# Error handling
# When one of multiple SQL statements causes an error, choose to either
# continue executing the remaining statements, or stopping
# Possible values "STOP" or "RESUME"
on_error = STOP

# Set threshold for row limit. Use 0 to disable limiting.
row_limit = 1000

# Skip intro on startup and goodbye on exit
less_chatty = False

# Postgres prompt
# \t - Current date and time
# \u - Username
# \h - Short hostname of the server (up to first '.')
# \H - Hostname of the server
# \d - Database name
# \p - Database port
# \i - Postgres PID
# \# - "@" sign if logged in as superuser, '>' in other case
# \n - Newline
# \dsn_alias - name of dsn alias if -D option is used (empty otherwise)
prompt = "\d\# "

# Number of lines to reserve for the suggestion menu
min_num_menu_lines = 4

# Character used to left pad multi-line queries to match the prompt size.
multiline_continuation_char = ""

# The string used in place of a null value.
null_string = "⟨NULL⟩"

# manage pager on startup
enable_pager = True

# Use keyring to automatically save and load password in a secure manner 
keyring = false
[colors]
completion-menu.completion.current = "bg:#ffffff #000000"
completion-menu.completion = "bg:#008888 #ffffff"
completion-menu.meta.completion.current = "bg:#44aaaa #000000"
completion-menu.meta.completion = "bg:#448888 #ffffff"
completion-menu.multi-column-meta = "bg:#aaffff #000000"
scrollbar.arrow = "bg:#003333"
scrollbar = "bg:#00aaaa"
selected = "#ffffff bg:#6666aa"
search = "#ffffff bg:#4444aa"
search.current = "#ffffff bg:#44aa44"
bottom-toolbar = "bg:#222222 #aaaaaa"
bottom-toolbar.off = "bg:#222222 #888888"
bottom-toolbar.on = "bg:#222222 #ffffff"
search-toolbar = noinherit bold
search-toolbar.text = nobold
system-toolbar = noinherit bold
arg-toolbar = noinherit bold
arg-toolbar.text = nobold
bottom-toolbar.transaction.valid = "bg:#222222 #00ff5f bold"
bottom-toolbar.transaction.failed = "bg:#222222 #ff005f bold"

# style classes for colored table output
output.header = "#729fcf"
output.odd-row = ""
output.even-row = ""

[data_formats]
decimal = ""
float = ""

