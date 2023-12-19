root=/home/zxp/baselines/act3d-chained-diffuser
data_dir=$root/data/raw
output_dir=$root/data/packaged
train_dir=18_peract_tasks_train
val_dir=18_peract_tasks_val
train_episodes_per_task=1
val_episodes_per_task=1
image_size="256,256"
task_file=tasks/peract_1_tasks.csv
processes=3

for task in $(cat $root/$task_file | tr '\n' ' '); do
    for split_dir in $train_dir $val_dir; do

      # A - Generate raw train and val data
      python RLBench/tools/dataset_generator.py \
          --save_path=$data_dir/$split_dir \
          --tasks=$(cat $root/$task_file | tr '\n' ',') \
          --image_size=$image_size \
          --renderer=opengl \
          --episodes_per_task=$train_episodes_per_task \
          --variations=-1 \
          --offset=0 \
          --processes=$processes

      # B - Preprocess train and val data
      python -m data_preprocessing.data_gen \
          --data_dir=$data_dir/$split_dir \
          --output=$output_dir/$split_dir \
          --image_size=$image_size \
          --max_variations=60 \
          --tasks=$task

      #3 - Preprocess Instructions for Both Datasets
      python -m data_preprocessing.preprocess_instructions \
          --tasks $(cat $root/$task_file | tr '\n' ' ') \
          --output instructions.pkl \
          --variations {0..199} \
          --annotations data_preprocessing/annotations.json

      #4 - Compute Workspace Bounds for Both Datasets
      output_dir=$root/data/packaged
      task_file=tasks/peract_1_tasks.csv
      python -m data_preprocessing.compute_workspace_bounds \
          --dataset $output_dir/$split_dir\
          --out_file 1_peract_tasks_location_bounds.json \
          --variations {0..199} \
          --tasks $(cat $task_file | tr '\n' ' ')
    done
done
