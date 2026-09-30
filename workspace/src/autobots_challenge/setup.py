from setuptools import setup

package_name = 'autobots_challenge'

setup(
    name=package_name,
    version='0.1.0',
    packages=[package_name],
    data_files=[
        ('share/ament_index/resource_index/packages', ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='AutoBots',
    maintainer_email='noreply@example.com',
    description='Empty ROS 2 package for the student PX4/Gazebo challenge',
    license='UNLICENSED',
    entry_points={'console_scripts': []},
)
