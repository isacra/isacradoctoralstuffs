from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import tensorflow as tf
import scipy.io
from numpy import dtype
from numpy.random.mtrand import shuffle

class DataSet(object):
    def __init__(self, images_list_path, lr_images_path, lr_test_path, num_epoch, batch_size):
        # filling the record_list
        input_file = open(images_list_path, 'r')
        
        
        self.record_list = []
        self.record_lr = []
        self.record_test = []
        self.num_channels = 1
    
        for line in input_file:
          line = line.strip()
          self.record_list.append(line)
        filename_queue = tf.train.string_input_producer(self.record_list,shuffle=False)
        image_reader = tf.WholeFileReader()
        _, image_file = image_reader.read(filename_queue)
        #image = tf.image.decode_jpeg(image_file, 3)
        image = tf.image.decode_jpeg(image_file, self.num_channels)
        
        lr_input_file = open(lr_images_path, 'r')
        for line_lr in lr_input_file:
           line_lr = line_lr.strip()
           self.record_lr.append(line_lr)
        filename_queue_lr = tf.train.string_input_producer(self.record_lr,shuffle=False)
        image_reader_lr = tf.WholeFileReader()
        _, image_file_lr = image_reader_lr.read(filename_queue_lr)
        #lr_inputs = tf.image.decode_jpeg(image_file_lr, 3)
        lr_inputs = tf.image.decode_jpeg(image_file_lr, self.num_channels)
        
        hr_image = tf.image.resize_images(image, [32, 32])
        lr_image = tf.image.resize_images(lr_inputs, [32, 32])
        
        hr_image = tf.cast(hr_image, tf.float32)
        lr_image = tf.cast(lr_image, tf.float32)
        
        #
        
        min_after_dequeue = 256
        capacity = min_after_dequeue + 3 * batch_size
        self.hr_images, self.lr_images = tf.train.shuffle_batch([hr_image, lr_image], batch_size=batch_size, num_threads=1, capacity=capacity,min_after_dequeue=min_after_dequeue)

    def get_corr_white_noise_imgs(self):
        
        mat = scipy.io.loadmat('../data/Cunha/images.mat')
        simulation = mat['images']
        return simulation
    