bruce
=====

You wouldn't like me when I'm angry.
------------------------------------

Bruce is a toy banner serving platform. It is build on Sinatra to reduce stack
size and increase the amount of request per second on a small instance.
It rarely touches the database and serves most requests directly out of Redis.

It allows the creation of Campaigns with a selection of Banners.
The Banners can be assigned weights through the Selection join table.
These are all pure persistance classes that contain no business logic.
In general, I have attempted to limit the responsibilities per class as much as practical.

For the creation of lists, a `ListGenerator` class is used to mix two sets of objects according to a preset ratio.
The `ListGenerator` class takes two separate `Strategy` classes to generate sets of objects. These `Strategy` classes must respond to the `#pick` method. This decouples the creation of the list from the creation of the source sets. The ratios are normalized and each `Strategy` is asked to provide its share of the list.

Two example `Strategies` are provided:
- `RandomBanner`, which does a simple Ruby `#sample`
- `WeightedBanner`, which takes a set of banners with weights to provide a weighted randomization.
  This is currently done using a pretty memory hungry method.

The Strategies are only expected to respond to the #pick method. No assumptions
are made with *what* kind of objects the lists are populated.

Once a list of banners is generated, it is cached in a Redis queue by the
`RedisClient` class. This class also provides namespaces for development
environments. All database operations are performed in a block of the `#cache`
method. This block only runs when the `settings.expire_time` has expired.

The `#banners` method then creates a list of Banners from the resulting list
using the BannerFactory.

To be duck-typed as a Banner, an object currently only needs to respond to the `#url` method.
The `BannerFactory` simply checks the existence of this method or attempts to
use the object as an initialization Hash for a new Banner. This factory could be
used in the future for more complicated initialization behavior.

At each request, the list is retrieved from the queue and a single banner is chosen from the collection.
The `Frontend` class is used to make sure a client does not see the same banner twice in a row.
It takes a list of something and an object and checks if the same object was
previously returned. It then stores the returned object in Redis for the next
call. This class currently only employs the `request.ip`, but could inlude any number of client attributes.

The app can be administered from an admin interface at /admin.
Run `rake ar:setup` on a local install to setup the database and provide admin credentials.
