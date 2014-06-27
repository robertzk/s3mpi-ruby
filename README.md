S3MPI 
=========

Upload and download Ruby objects to S3 using a very convenient API.


Usage
-----

To set up an S3 interface, one can run

```ruby
MPI = S3MPI::Interface.new('bucket', 'path/in/bucket')
# or a constant name of your choosing
```

Then, assuming our [credentials are set up correctly](https://aws.amazon.com/articles/8621639827664165),
we can store and read Ruby objects:

```ruby
MPI.store({some: 'ruby', object: 5}, 'some_object')
MPI.read('some_object')
```

[![Build Status](https://travis-ci.org/robertzk/s3mpi.svg?branch=master)](https://travis-ci.org/robertzk/s3mpi)
[![Code Climate](https://codeclimate.com/github/robertzk/s3mpi.png)](https://codeclimate.com/github/robertzk/s3mpi)

