#task_names=('place_cups' 'light_bulb_in' 'place_wine_at_rack_location' 'put_groceries_in_cupboard'
#'slide_block_to_color_target' 'sweep_to_dustpan_of_size' 'stack_blocks' 'close_jar' 'insert_onto_square_peg'
#'put_money_in_safe' 'meat_off_grill' 'open_drawer' 'reach_and_drag' 'push_buttons' 'stack_cups' 'turn_tap'
#'put_item_in_drawer' 'place_shape_in_shape_sorter')
task_names=('place_wine_at_rack_location')
for task in "${task_names[@]}"; do
    for split_dir in 'train' 'val'; do
      python RLBench/tools/dataset_generator.py \
      --save_path=/home/zxp/baselines/act3d-chained-diffuser/data/$split_dir \
      --tasks=$task \
      --image_size="256,256" \
      --renderer=opengl \
      --episodes_per_task=10 \
      --variations=-1 \
      --offset=0 \
      --processes=3
    done
done
