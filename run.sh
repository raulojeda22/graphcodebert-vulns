#!/bin/bash

scale=xsmall
lr=1e-4
batch_size=3
beam_size=5
source_length=320
target_length=256
output_dir=saved_models/$scale/
train_file=data/$scale/train.buggy-fixed.buggy,data/$scale/train.buggy-fixed.fixed
dev_file=data/$scale/valid.buggy-fixed.buggy,data/$scale/valid.buggy-fixed.fixed
epochs=10 
pretrained_model=microsoft/graphcodebert-base

mkdir -p $output_dir
python3.10 run.py --do_train --do_eval --model_type roberta --model_name_or_path $pretrained_model --tokenizer_name microsoft/graphcodebert-base --config_name microsoft/graphcodebert-base --train_filename $train_file --dev_filename $dev_file --output_dir $output_dir --max_source_length $source_length --max_target_length $target_length --beam_size $beam_size --train_batch_size $batch_size --eval_batch_size $batch_size --learning_rate $lr --num_train_epochs $epochs 2>&1| tee $output_dir/train.log

# batch_size=64
# dev_file=data/$scale/valid.buggy-fixed.buggy,data/$scale/valid.buggy-fixed.fixed
# test_file=data/$scale/test.buggy-fixed.buggy,data/$scale/test.buggy-fixed.fixed
# load_model_path=$output_dir/checkpoint-best-bleu/pytorch_model.bin #checkpoint for test

# python3.10 run.py --do_test --model_type roberta --model_name_or_path $pretrained_model --tokenizer_name microsoft/graphcodebert-base --config_name microsoft/graphcodebert-base --load_model_path $load_model_path --dev_filename $dev_file --test_filename $test_file --output_dir $output_dir --max_source_length $source_length --max_target_length $target_length --beam_size $beam_size --eval_batch_size $batch_size 2>&1| tee $output_dir/test.log