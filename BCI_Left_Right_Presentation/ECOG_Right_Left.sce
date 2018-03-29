## Scenario File for ECOG BCI experiment
## v1.0 Abhinuv

response_matching = simple_matching;
default_font_size = 48;
# TODO:: check if this is needed or not
write_codes = true;
pulse_width = indefinite_port_code;

begin;

# Introduction - Text
text { caption = "Please take a deep breath, relax and the experiment will start in 5 seconds";} intro_text;

# Instruction - Text
text { caption = "You will be presented with the following stimuli";} instr_text_1;
text { caption = "For the left arrow, please imagine doing X";} instr_text_2;
text { caption = "For the right arrow, please imagine doing Y";} instr_text_3;

# Array for the text
array {
   text { caption = "Left Arrow"; description = "Left Arrow"; } left;
   text { caption = "Right Arrow"; description = "Right Arrow"; } right;   
} arrows;

# Array for the images
array {
   bitmap { filename = "left.jpg"; description = "Left Arrow Picture"; } left_pic;
   bitmap { filename = "right.jpg"; description = "Right Arrow Picture"; } right_pic;
} arrow_pictures;

# Introduction trial
trial{
	picture{
		text intro_text;
		x = 0;y = 0;
	} intro_pic;	
	time = 0;
	duration = 10000;
}intro_trial;

# Introduction trial
trial{
	picture{
		text instr_text_1;
		x = 0;y = 400;
		bitmap left_pic;
		x = 200; y = 200;
		bitmap right_pic;
		x = -200; y = 200;		
		text instr_text_2;
		x = 0; y = 0;
		text instr_text_3;
		x = 0; y = -200;
		
	} instr_pic;	
	time = 0;
	duration = 5000;
}instr_trial;

# The actual trial
trial {
   trial_duration = 2000;

   stimulus_event {
      picture {
         text left;
			x = 0; y = 0;
			bitmap left_pic;
         x = 0; y = 100;
      } pic;
      time = 0;
      duration = 1000;
   } event1;
   } main_trial;

# The wait trial
trial {
   trial_duration = 1000;
   } wait_trial;

# Main Function - This is where the code execution starts
begin_pcl;

# Create an array to snyc the text and the picture
if (output_port_manager.port_count() == 0) then
   term.print( "Forgot to add an output port!" )
end;
output_port oport = output_port_manager.get_port( 1 );

array<int> index[2];
index[1] = 1;
index[2] = 2;

instr_trial.present();
intro_trial.present();
loop int i = 1 until i > 5 begin
	index.shuffle();
	pic.set_part(1, arrows[index[1]]);
	event1.set_event_code(arrows[index[1]].description());	
	oport.send_code(index[1]);
	term.print(index[1]);
	main_trial.present();
	wait_trial.present();
	i = i + 1
	end
