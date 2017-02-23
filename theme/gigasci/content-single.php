<div class="row">

    <div class="col-sm-9 blog-main">

<div class="blog-post">
	<h2 class="blog-post-title"><?php the_title(); ?></h2>
	<p class="blog-post-meta"><?php the_date(); ?> by <a href="#"><?php the_author(); ?></a></p>
	<?php the_content(); ?>
</div><!-- /.blog-post -->
    </div>

    <div class="col-sm-3 blog-sidebar">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Author</h3>
            </div>
            <div class="panel-body">
                <p>Stuff goes here</p>
            </div>

        </div>

        <div class="sidebar-module">
            <div class="panel panel-default">
                <div class="panel-heading">

                    <h3 class="panel-title "><span class="glyphicon glyphicon-envelope"></span> Subscribe to GigaBlog</h3>

                </div>
                <div class="panel-body">
                    <input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="Enter your email">
                </div>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Archive</h3>
                </div>
                <div class="panel-body">
                    <ol class="list-unstyled">
						<?php wp_get_archives( 'type=monthly&limit=6&show_post_count=true' ); ?>
                    </ol>
                </div>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Popular tags</h3>
                </div>
                <div class="panel-body">
					<?php the_tags( '<ul class="list-unstyled list-group"><li>', '</li><li>', '</li></ul>' ); ?>
                </div>
            </div>
        </div>
    </div><!-- /.blog-sidebar -->
</div>

