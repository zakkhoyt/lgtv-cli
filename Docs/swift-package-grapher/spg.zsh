#!/usr/bin/env -S zsh -euo pipefail
# shellcheck shell=bash # trick shellcheck into working with zsh
# shellcheck disable=SC2296 # Falsely identifies zsh expansions
#
# ---- ---- ----  About this Script  ---- ---- ----
#

# $HOME/code/repositories/z2k/github/lgtv-cli/Docs/swift-package-grapher/spg.zsh \
#   --package-dir "$HOME/code/repositories/z2k/github/lgtv-cli" \
#   --package-dir "$HOME/code/repositories/hatch/hatch_mobile/HatchTerminal" \
#   --output-dir "$HOME/temp/spg-output" -d -d -d

# $HOME/code/repositories/z2k/github/lgtv-cli/Docs/swift-package-grapher/spg.zsh \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchAssets" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchSleep" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchAlarmWidget" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchContent" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchFeatureFlagStatsig" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchTools" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchUtilities" \
# --output-dir "$HOME/temp/spg-output" -d -d -d
# $HOME/code/repositories/z2k/github/lgtv-cli/Docs/swift-package-grapher/spg.zsh \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchModels" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchServiceBackendClient" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchUIComponents" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchHUD" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchServiceBackendAPI" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchFeatureFlagAPI" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchDeviceActivityMonitorExtension" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchBrain" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchUI" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchModules" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchLogger" \
# --package-dir "$HOME/code/repositories/hatch/hatch_sleep/0/iOS/hatch-sleep-app/HatchDevices" \
# --output-dir "$HOME/temp/spg-output" -d -d -d
# ---- ---- ---- ----  Imports  ---- ---- ---- ----

source "$HOME/.zsh_home/utilities/.zsh_boilerplate" "$0" "$@"

# ---- ---- ----   Argument Parsing   ---- ---- ----

# ---- ---- ----     Script Work     ---- ---- ----

zparseopts -E -D -- \
  -package-dir+:=opt_package_dirs \
  -output-dir:=opt_output_dir
slog_var1_se "opt_package_dirs"

typeset -a package_dirs=(${opt_package_dirs:#--package-dir})
slog_var1_se "package_dirs"

typeset -r output_dir="${opt_output_dir[-1]:-}"
slog_var1_se "output_dir"

local i=0
local package_dir=''
typeset -a output_files=()

slog_se_d "package_dirs.count: ${#package_dirs[@]}" 1>&2
for ((i=0; i<="${#package_dirs[@]}"; i++)); do
  slog_var1_se "i"
  package_dir="${package_dirs[$i]:-}"
  if [[ -z "$package_dir" ]]; then continue; fi
  slog_se_d "  \${package_dirs[$i]}: $package_dir" 1>&2

  package_name="$(basename "$package_dir")"
  slog_var1_se_d "package_name"
  
  output_package_dir="${output_dir}/${package_name}"
  slog_var1_se_d "output_package_dir"

  mkdir_cmd=(mkdir -p "$output_package_dir")
  slog_se --code "${mkdir_cmd[*]}" --default
  "${mkdir_cmd[@]}"
  
  cmd=(swift package resolve --package-path "$package_dir")
  output_file="${output_package_dir}/${package_name}-resolve.log"
  slog_se --code "${cmd[*]} > \"$output_file\"" 1>&2
  [[ -z "$flag_dry_run" ]] && "${cmd[@]}" > "$output_file"
  output_files+=("$output_file")

  output_file="$output_package_dir/Package.swift"
  cmd=(cp "$package_dir/Package.swift" "$output_file")
  slog_se --code "${cmd[*]} > \"$output_file\"" 1>&2
  [[ -z "$flag_dry_run" ]] && "${cmd[@]}" > "$output_file"
  output_files+=("$output_file")  

  output_file="$output_package_dir/Package.resolved"
  cmd=(cp "$package_dir/Package.resolved" "$output_file")
  slog_se --code "${cmd[*]} > \"$output_file\"" 1>&2
  [[ -z "$flag_dry_run" ]] && "${cmd[@]}" > "$output_file"
  output_files+=("$output_file")

  # ------------ swift package describe ------------ 

  output_swift_package_describe_dir="${output_package_dir}/swift-package-describe"
  slog_var1_se_d "output_swift_package_describe_dir"

  mkdir_cmd=(mkdir -p "$output_swift_package_describe_dir")
  slog_se --code "${mkdir_cmd[*]}" --default
  "${mkdir_cmd[@]}"

  types=(json text mermaid)
  for type in "${types[@]}"; do
    slog_var1_se_d "type"
    output_file="${output_swift_package_describe_dir}/${package_name}-describe.${type}"
    cmd=(swift package describe --package-path "$package_dir" --type "$type")
    slog_se --code "${cmd[*]} > \"$output_file\"" 1>&2
    [[ -z "$flag_dry_run" ]] && "${cmd[@]}" > "$output_file"
    output_files+=("$output_file")
  done

  # ------------ swift package show-dependencies ------------ 

  output_swift_package_show_dependencies_dir="${output_package_dir}/swift-package-show-dependencies"
  slog_var1_se_d "output_swift_package_show_dependencies_dir"
  
  mkdir_cmd=(mkdir -p "$output_swift_package_show_dependencies_dir")
  slog_se --code "${mkdir_cmd[*]}" --default
  "${mkdir_cmd[@]}"

  types=(text dot json flatlist)
  for type in "${types[@]}"; do
    slog_var1_se_d "type"
    output_file="${output_swift_package_show_dependencies_dir}/${package_name}-show-dependencies.${type}"
    cmd=(swift package show-dependencies --package-path "$package_dir" --format "$type")
    slog_se --code "${cmd[*]} > \"$output_file\"" 1>&2
    [[ -z "$flag_dry_run" ]] && "${cmd[@]}" > "$output_file"
    output_files+=("$output_file")
  done

  # ------------ swift package show-executables ------------ 

  output_swift_package_show_executables_dir="${output_package_dir}/swift-package-show-executables"
  slog_var1_se_d "output_swift_package_show_executables_dir"
  
  mkdir_cmd=(mkdir -p "$output_swift_package_show_executables_dir")
  slog_se --code "${mkdir_cmd[*]}" --default
  "${mkdir_cmd[@]}"

  types=(json flatlist)
  for type in "${types[@]}"; do
    slog_var1_se_d "type"
    output_file="${output_swift_package_show_executables_dir}/${package_name}-show-executables.${type}"
    cmd=(swift package show-executables --package-path "$package_dir" --format "$type")
    slog_se --code "${cmd[*]} > \"$output_file\"" 1>&2
    [[ -z "$flag_dry_run" ]] && "${cmd[@]}" > "$output_file"
    output_files+=("$output_file")
  done

  # ------------ swift package dump-package ------------ 

  output_swift_package_dump_package_dir="${output_package_dir}/swift-package-dump-package"
  slog_var1_se_d "output_swift_package_dump_package_dir"
  
  mkdir_cmd=(mkdir -p "$output_swift_package_dump_package_dir")
  slog_se --code "${mkdir_cmd[*]}" --default
  "${mkdir_cmd[@]}"

  types=(json)
  for type in "${types[@]}"; do
    slog_var1_se_d "type"
    output_file="${output_swift_package_dump_package_dir}/${package_name}-dump-package.${type}"
    cmd=(swift package dump-package --package-path "$package_dir")
    slog_se --code "${cmd[*]} > \"$output_file\"" 1>&2
    [[ -z "$flag_dry_run" ]] && "${cmd[@]}" > "$output_file"
    output_files+=("$output_file")
  done
done


slog_var1_se "output_files"

slog_se --url "$output_dir" --default
slog_se --code "open ${(q)output_dir}" --default