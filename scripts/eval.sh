exp=act3d

tasks=(
    place_wine_at_rack_location
)
data_dir=/home/zxp/baselines/act3d-chained-diffuser/data/raw/18_peract_tasks_val
num_episodes=100
gripper_loc_bounds_file=../1_peract_tasks_location_bounds.json
act3d_gripper_loc_bounds_file=../1_peract_tasks_location_bounds.json

use_instruction=1
act3d_use_instruction=0
headless=0
offline=0
max_tries=2
verbose=1
interpolation_length=50
single_task_gripper_loc_bounds=1
cameras="left_shoulder,right_shoulder,wrist"
num_ckpts=${#tasks[@]}
for ((i=0; i<$num_ckpts; i++)); do
  CUDA_LAUNCH_BLOCKING=1 python ../eval1.py \
    --tasks ${tasks[$i]} \
    --act3d_checkpoint train_logs/act3d/${tasks[$i]}/last.pth \
    --traj_model diffusion \
    --verbose $verbose \
    --model act3d \
    --action_dim 7 \
    --collision_checking 0 \
    --predict_keypose 1 \
    --predict_traj 0 \
    --diff_checkpoint diffusion_last.pth \
    --single_task_gripper_loc_bounds $single_task_gripper_loc_bounds \
    --data_dir $data_dir \
    --offline $offline \
    --num_episodes $num_episodes \
    --headless $headless \
    --output_file ../eval_logs/$exp/${tasks[$i]}.json  \
    --exp_log_dir ../eval_logs/$exp \
    --run_log_dir ${tasks[$i]}-ONLINE \
    --use_instruction $use_instruction \
    --act3d_use_instruction $act3d_use_instruction \
    --instructions ../instructions.pkl \
    --max_tries $max_tries \
    --max_steps -1 \
    --gripper_loc_bounds_file $gripper_loc_bounds_file \
    --act3d_gripper_loc_bounds_file $act3d_gripper_loc_bounds_file \
    --interpolation_length $interpolation_length \
    --dense_interpolation 1
done

