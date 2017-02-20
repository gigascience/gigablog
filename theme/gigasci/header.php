
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	<meta name="description" content="">
	<meta name="author" content="">

	<title>Blog Template for Bootstrap</title>

	<!-- Bootstrap core CSS -->
	<link rel="stylesheet"
		  href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
		  integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
		  crossorigin="anonymous">

	<!-- Optional theme -->
	<link rel="stylesheet"
		  href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css"
		  integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp"
		  crossorigin="anonymous">

	<!-- Latest compiled and minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
			integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
			crossorigin="anonymous"></script>

	<!-- Custom styles for this template -->
	<link href="<?php bloginfo('template_directory');?>/test.css" rel="stylesheet">


	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
</head>

<body>

<div class="blog-masthead">
		<nav class="navbar navbar-default navbar-static-top">
			<div class="container">
				<div class="navbar-header">
					<button type="button"
                            class="navbar-toggle collapsed"
                            data-toggle="collapse"
                            data-target="#navbar"
                            aria-expanded="false"
                            aria-controls="navbar">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="#">GigaBlog</a>
					<a class="navbar-text" href="#">Data-driven blogging by the GigaScience editors</a>
				</div>
				<div id="navbar" class="navbar-collapse collapse navbar-right">
					<ul class="nav navbar-nav">
						<li><a class="navbar-brand" href="https://www.facebook.com/GigaScience/">
                                <img src="<?php bloginfo('template_directory');?>/inc/images/Facebook.svg" width="30" height="30" alt="">
                            </a>
                        <li><a class="navbar-brand" href="https://twitter.com/GigaScience">
                                <img src="<?php bloginfo('template_directory');?>/inc/images/Twitter.svg" width="30" height="30" alt="">
                            </a>
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li><a href="https://plus.google.com/+GigaScienceJournal">Google+</a></li>
                                <li><a href="https://www.linkedin.com/company/gigascience">LinkedIn</a></li>
								<li><a href="http://weibo.com/gigasciencejournal">Sina Webo</a></li>
							</ul>
						</li>
					</ul>
					<form class="navbar-form navbar-right"> 
						<div class="form-group"> 
							<input type="text" class="form-control" placeholder="Search"> 
						</div> 
						<button type="submit" class="btn btn-default">Submit</button>
					</form>

				</div><!--/.nav-collapse -->
			</div><!--/.container -->
		</nav>
</div>

<div class="container">