<div class="row">

    <div class="col-md-8">
        <div class="blog-post">
            <h2 class="blog-post-title"><?php the_title(); ?></h2>
            <p class="blog-post-meta"><?php the_date(); ?></p>
			<?php the_content(); ?>
        </div><!-- /.blog-post -->
    </div>

    <div class="col-md-3 col-md-offset-1">
        <div class="sidebar-author">
			<?php echo get_avatar( get_the_author_meta( 'ID' ), 72 ); ?>
            <h3 class="sidebar-content"><?php the_author_posts_link(); ?></h3>
        </div>
        <div class="panel-body">
            <p class="sidebar-content"><?php the_author_description(); if(!get_the_author_description()) _e('No description. Please update your profile.','lightword'); ?></p>
        </div>


        <div class="sidebar-module">
            <div class="panel-heading">
                <h3 class="panel-title sidebar-title"><span
                            class="glyphicon glyphicon-envelope"></span>
                    Subscribe to GigaBlog</h3>
            </div>
            <div class="panel-body">
                <input type="email" class="form-control"
                       id="exampleInputEmail1"
                       aria-describedby="emailHelp"
                       placeholder="Enter your email">
            </div>

            <div class="panel-heading">
                <h3 class="panel-title sidebar-title">Archive</h3>
            </div>
            <div class="panel-body">
                <ol class="list-unstyled">
					<?php wp_get_archives( 'format=custom&before=<p class="sidebar-content">&after=</p>&type=monthly&limit=6' ); ?>
                </ol>
            </div>

            <div class="panel-heading">
                <h3 class="panel-title sidebar-title">Popular tags</h3>
            </div>
            <div class="panel-body">
				<?php the_tags( '<ul class="list-unstyled list-group"><li class="sidebar-content">', '</li><li class="sidebar-content">', '</li></ul>' ); ?>
            </div>
        </div>
    </div><!-- /.blog-sidebar -->
</div>

