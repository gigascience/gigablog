<div class="col-sm-3 blog-sidebar">
    <div class="panel panel-default">
        <div id="twitter_timeline" style="height:400px;">
            <a class="twitter-timeline" data-theme="light"
               data-dnt="true" height="400"
               href="https://twitter.com/gigascience"
               data-widget-id="385649284785266688">Tweets by
                @GigaScience</a>
            <script>!function (d, s, id) {
                    var js, fjs = d.getElementsByTagName(s)[0], p = /^http:/.test(d.location) ? 'http' : 'https';
                    if (!d.getElementById(id)) {
                        js = d.createElement(s);
                        js.id = id;
                        js.src = p + "://platform.twitter.com/widgets.js";
                        fjs.parentNode.insertBefore(js, fjs);
                    }
                }(document, "script", "twitter-wjs");</script>
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