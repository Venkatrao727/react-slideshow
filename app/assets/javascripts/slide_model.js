var SL = SL || {};
SL.SlideModel = Backbone.Model.extend({
	urlRoot: "/slides",
	defaults: {
		title:"Add a title",
		content:"Content goes here",
		position: 0
	},
	
	parse: function(response) {
		return response;
	},

	handleTitleChange: function() {
	},

	handleSubmit: function() {
		if(this.isNew()) {
			$.ajax({
				context: this,
				type: "post",
				url: "http://localhost:3000/slides",
				data: {slide: this.toJSON()},
				dataType: "json",
				success: function(rsltData) {
					this.set({
						id: rsltData.id,
					});
		        }
		    });
		} else {
			$.ajax({
				context: this,
				type: "put",
				url: "http://localhost:3000/slides"+"/"+this.get("id"),
				data: {slide: this.toJSON() },
				dataType: "json",
				success: function(rsltData) {
		        }
		    });	
		}
	},

	initialize: function() {
		this.on("change:title", this.handleTitleChange, this);
	},
});

SL.SlideCollection = Backbone.Collection.extend({
	model: SL.SlideModel,
	url: "/slides",
	comparator: function(slide) {
		return slide.get("position");
	},

	initialize: function() {
	}
});

SL.SlidesList = new SL.SlideCollection();