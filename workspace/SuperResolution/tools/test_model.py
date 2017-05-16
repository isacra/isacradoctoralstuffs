import tensorflow as tf

'''
Created on 1 de abr de 2017

@author: isaac
'''
def main(_):
 
    with tf.Session() as sess:

        new_saver = tf.train.import_meta_graph('models/model.ckpt-10.meta')
        new_saver.restore(sess, 'models/model.ckpt-10')

        all_vars = tf.get_collection('vars')
        for v in all_vars:
            v_ = sess.run(v)
        print(v_)
        print("Model restored.")
  
if __name__ == '__main__':
    tf.app.run()