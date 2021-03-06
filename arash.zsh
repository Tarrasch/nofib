# Just some commands here so I don't have to rely on my zsh shell history
#
# Usage (from zsh): `ik nofib && source arash.zsh`
#

() {
  ik 'nofib' || return 1

  # Ett realworld-example
  # make clean && make boot && make -k 2>&1 EXTRA_HC_OPTS='-g' EXTRA_RUNTEST_OPTS='+RTS --stack-trace -RTS' mode=fast NoFibRuns=1 | tee results/log-fast-1-stack-trace
  local DATE=$(date +%m-%d-%T)

  # Change these variables

  local EXTRA_HC_OPTS
  local EXTRA_RUNTEST_OPTS
  EXTRA_HC_OPTS=( -g )
  # EXTRA_RUNTEST_OPTS=( +RTS --stack-trace -RTS )
  # EXTRA_HC_OPTS=()
  EXTRA_RUNTEST_OPTS=()
  local LOG_FILE_NAME="log-fast-1${EXTRA_HC_OPTS}${EXTRA_RUNTEST_OPTS[2]}-$DATE"
  # ${EXTRA_RUNTEST_OPTS[2]} hack evaluates to --stack-trace

  make clean                                         \
    && make boot                                     \
    && make -k 2>&1 -j4                               \
        EXTRA_HC_OPTS="$EXTRA_HC_OPTS"                 \
        EXTRA_RUNTEST_OPTS="$EXTRA_RUNTEST_OPTS" \
        mode=fast NoFibRuns=1                        \
    | tee "results/${LOG_FILE_NAME}"             \
}

analyse () {
 ./nofib-analyse/nofib-analyse log-fast-1-wtih-dash-g log-fast-1-stack-trace | less
}
