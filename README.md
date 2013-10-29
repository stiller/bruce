bruce
=====

You wouldn't like me when I'm angry.
------------------------------------

Bruce is a toy banner serving platform. It uses a `ListGenerator` class to mix two sets of banners according to a preset ratio.
The `ListGenerator` class takes two separate classes to generate sets of banners. These classes must respond to the `#pick` method.

Two example classes are provided: 
- `RandomBanner`, which does a simple Ruby `#sample`
- `WeightedBanner`, which takes a set of banners with weights to provide a weighted randomization.

The banners are stored in a database, which can be administered from an admin interface at /admin.
Run `rake ar:setup` on a local install to setup the database and provide admin credentials.

Once a list of banners is generated, it is cached in a Redis queue. This queue is refreshed every n seconds.
At each request, the list is retrieved from the queue and a single banner is chosen from the collection.
The `#get_new_value_for` method is used to make sure a client does not see the same banner twice in a row.
This method currently only employs the client ip, but could inlude any number of client attributes.
