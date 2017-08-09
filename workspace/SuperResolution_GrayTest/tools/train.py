import tensorflow as tf
from solver import *

flags = tf.app.flags

#solver
flags.DEFINE_string("train_dir", "models", "trained model save path")
flags.DEFINE_string("samples_dir", "samples", "sampled images save path")
flags.DEFINE_string("imgs_list_path", "../data/Cunha/hr_train.txt", "images list file path")
flags.DEFINE_string("lr_imgs_list_path", "../data/Cunha/lr_train.txt", "images list file path")
flags.DEFINE_string("lr_imgs_test_path", "../data/lr_test.txt", "images list file path")
flags.DEFINE_boolean("use_gpu", True, "whether to use gpu for training")
flags.DEFINE_integer("device_id", 0, "gpu device id")

flags.DEFINE_integer("num_epoch", 30, "train epoch num")
flags.DEFINE_integer("batch_size", 32, "batch_size")

flags.DEFINE_float("learning_rate", 4e-4, "learning rate")

conf = flags.FLAGS

def main(_):
  solver = Solver()
  sess = solver.train()
  #solver.test(sess)
  
if __name__ == '__main__':
  tf.app.run()