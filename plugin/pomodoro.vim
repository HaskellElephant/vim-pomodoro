" plugin/pomodoro.vim
" Author:   Maximilian Nickel <max@inmachina.com>
" License:  MIT License 
"
" Vim plugin for the Pomodoro time management technique. 
"
" Commands:
" 	:PomodoroStart [name] 	- 	Start a new pomodoro. [name] is optional,
" 	  mapped to <F7> by default.
" 	:PomodoroStatus         -   Gives the remaining time left of the current
" 	  pomodoro, mapped to <F6> by default.
"
" 	Once a pomodoro is finished a buffer is opened where you can type in a log
" 	message that will be added to the logfile.
"
" Configuration: 
" 	g:pomodoro_time_work 	-	Duration of a pomodoro 
" 	g:pomodoro_time_slack 	- 	Duration of a break 
" 	g:pomodoro_log_file 	- 	Path to log file

if &cp || exists("g:pomodoro_loaded") && g:pomodoro_loaded
  finish
endif

let g:pomodoro_loaded = 1
let g:pomodoro_started = 0
let g:pomodoro_started_at = -1 

let g:pomodoro_time_work = 50
let g:pomodoro_time_slack = 10

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* PomodoroStatus call s:PomodoroStatus()
nmap <F6> <ESC>:PomodoroStatus<CR>
command! -nargs=* PomodoroStart call s:PomodoroStart(<q-args>)
nmap <F7> <ESC>:PomodoroStart<CR>

function! s:PomodoroStatus() 
  if g:pomodoro_started == 0
    echomsg "Pomodoro inactive"
  elseif g:pomodoro_started == 1
    echomsg "Pomodoro started (remaining: " . pomodorocommands#remaining_time() . ".)"
  elseif g:pomodoro_started == 2
    echomsg "Pomodoro break started"
  endif
endfunction

function! s:PomodoroStart(name)
  if g:pomodoro_started != 1
    if a:name == ''
      let name = '(unnamed)'
    else 
      let name = a:name
    endif
    call asynccommand#run("sleep " . g:pomodoro_time_work * 60, pomodorohandlers#pause(name)) 
    let g:pomodoro_started_at = localtime()
    let g:pomodoro_started = 1 
  endif
endfunction
