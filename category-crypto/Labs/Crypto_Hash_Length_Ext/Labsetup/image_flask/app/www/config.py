import os


class Config(object):
    LAB_HOME_DIR = os.getcwd() + '/LabHome'
    KEY_FILE_NAME = 'key.txt'
    DUMMY_FILE = 'secret.txt'
    DEFAULT_USER_ID = 1001
    DEFAULT_USER_KEY = '123456'
    KEY_FILE_DELIMITER = ':'
