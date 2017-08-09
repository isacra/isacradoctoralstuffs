import tensorflow as tf
import numpy
import matplotlib.pyplot as plt
import sys
import scipy.io
import numpy as np
from data import *
from utils import *

rng = numpy.random
'''
Created on 27 de jul de 2017

@author: isaac
'''

flags = tf.app.flags
flags.DEFINE_string("checkpoint_dir", "models", "trained model save path")
flags.DEFINE_string("test_dir", "test", "trained model save path")

conf = flags.FLAGS

def main(_):
    
    #mat = scipy.io.loadmat('../data/Cunha/images.mat')
    mat = scipy.io.loadmat('../data/Cunha/images_estranhas.mat')
    simulation_data = mat['images']
    mu=1.1
    
    
    with tf.Session(config=tf.ConfigProto(allow_soft_placement=True)) as sess:
        #train = tf.placeholder(tf.bool)
        
        saver = tf.train.import_meta_graph(conf.checkpoint_dir+'/model.ckpt-10000.meta')
        ckpt = tf.train.get_checkpoint_state(conf.checkpoint_dir)
        sess.run(tf.global_variables_initializer())
            
        if ckpt and ckpt.model_checkpoint_path:
            saver.restore(sess, tf.train.latest_checkpoint(conf.checkpoint_dir))
            
        clogits = tf.get_collection("clogits")[0]
        plogits = tf.get_collection("plogits")[0]
        lr_imgs = tf.get_collection("lrimages")[0]
        hr_imgs = tf.get_collection("hrimages")[0]
        train = tf.get_collection("train")[0]
            
        np_lr_imgs = np.reshape(simulation_data,[32,32,32,1])
        np_lr_imgs = np.float32(np_lr_imgs)
        #dad = sess.run(plogits, feed_dict={hr_imgs:np_lr_imgs})
        np_c_logits = sess.run(clogits, feed_dict={lr_imgs:np_lr_imgs, train:False})
        gen_hr_imgs = np.zeros((32, 32, 32, 1), dtype=np.float32)
        for i in range(32):
            for j in range(32):
                for c in range(1):
                    
                    np_p_logits = sess.run(plogits, feed_dict={hr_imgs: gen_hr_imgs})
                    new_pixel = logits_2_pixel_value(np_c_logits[:, i, j, c*256:(c+1)*256] + np_p_logits[:, i, j, c*256:(c+1)*256], mu=mu)
                    gen_hr_imgs[:, i, j, c] = new_pixel
        save_samples(gen_hr_imgs, conf.test_dir+'/gen_test_model' + '/generate_' + str(mu*10))
    a = 10

if __name__ == '__main__':
    tf.app.run()