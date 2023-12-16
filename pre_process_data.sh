#task_names=('place_cups' 'light_bulb_in' 'place_wine_at_rack_location' 'put_groceries_in_cupboard'
#'slide_block_to_color_target' 'sweep_to_dustpan_of_size' 'stack_blocks' 'close_jar' 'insert_onto_square_peg'
#'put_money_in_safe' 'meat_off_grill' 'open_drawer' 'reach_and_drag' 'push_buttons' 'stack_cups' 'turn_tap'
#'put_item_in_drawer' 'place_shape_in_shape_sorter')
task_names=('place_wine_at_rack_location')

# B Preprocess train and val data
for task in "${task_names[@]}"; do
    for split_dir in 'train'; do
        python -m data_preprocessing.data_gen \
            --data_dir=/home/zxp/projects/C2F_bi_equi/c2f_bi_equi_data/$split_dir \
            --output=/home/zxp/baselines/act3d-chained-diffuser/data/$split_dir \
            --image_size="256,256" \
            --max_variations=60 \
            --tasks=$task
    done
done

# 3 - Preprocess Instructions for Both Datasets
for task in "${task_names[@]}"; do
    for split_dir in 'train'; do
      python -m data_preprocessing.preprocess_instructions \
      --tasks=$task \
      --output=instructions.pkl \
      --variations={0..199} \
      --annotations=data_preprocessing/annotations.json
    done
done

# 4 - Compute Workspace Bounds for Both Datasets
for task in "${task_names[@]}"; do
    python -m data_preprocessing.compute_workspace_bounds \
        --dataset=/home/zxp/baselines/act3d-chained-diffuser/data/val \
        --out_file=1_peract_tasks_location_bounds.json \
        --variations={0..199} \
        --tasks=$task
done
