## Scenario File for ECOG BCI experiment
## Left vs Right
## v1.0 Abhinuv
## v1.1 Abhinuv - Changed the task to match physio dataset

response_matching = simple_matching;
default_font_size = 48;
# TODO:: check if this is needed or not
write_codes = true;
pulse_width = indefinite_port_code;
default_background_color = 255,255,255;
default_text_color = 0,0,0;

begin;
 
# Introduction - Text
text { caption = "Please take a deep breath, \n relax and the experiment will start in 5 seconds";} intro_text;

# Instruction - Text
text { caption = "You will be presented with the following stimuli";} instr_text_1;
text { caption = "For the left arrow, please imagine moving your left hand";} instr_text_2;
text { caption = "For the right arrow, please imagine moving your right hand";} instr_text_3;
text { caption = "Please do not close your eyes to imagine.\n If the screen is blank, you can just relax";} instr_text_4;
text { caption = "";} no_text;

# Array for the text
array {
   text { caption = "Left Hand"; description = "Left Arrow"; } left;
   text { caption = "Right Hand"; description = "Right Arrow"; } right; 
	text { caption = ""; description = "No Arrow";} no_arrow;
} arrows;

# Array for the images
array {
   bitmap { filename = "left.jpg"; description = "Left Arrow Picture"; } left_pic;
   bitmap { filename = "right.jpg"; description = "Right Arrow Picture"; } right_pic;
	bitmap { filename = "nope.jpg";description = "No Pic";} no_pic;
} arrow_pictures;

# Image for for the initial wait trial
bitmap { filename = "cross.jpg"; description = "Cross";}cross_pic;
# Instruction trial
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
		text instr_text_4;
		x = 0; y = -400;		
	} instr_pic;	
	time = 0;
}instr_trial;

# Introduction trial
trial{
	picture{
		text intro_text;
		x = 0;y = 0;
	} intro_pic;	
	time = 0;	
}intro_trial;


# The actual trial
trial {
   stimulus_event {
      picture {
         text left;
			x = 0; y = 0;
			bitmap left_pic;
         x = 0; y = 100;
      } pic;
      time = 0;      
   } event1;
   } main_trial;

# The wait trial
trial {  
	picture{
		text no_text;
		x = 0;y = 0;
		bitmap cross_pic;
		x=0;y=0;
	} no_text_pic;	
	time = 0;	 
   } wait_trial;


##########################################################
# Main Function - This is where the code execution starts#
##########################################################
begin_pcl;
# Experiment Parameters
int instr_duration = 1500;
int intro_duration = 2000;
# TODO: These can be randomised later
int wait_duration = 1000;
int main_duration = 4000;
int wait_main_duration = 3000;

# Port OUT definations
int instr_code = 100;
int intro_code = 101;
int wait_code = 50;
int left_code = 1;
int right_code = 2;
int no_code = 3;


int number_of_trials = 5;
instr_trial.set_duration(instr_duration);
intro_trial.set_duration(intro_duration);
wait_trial.set_duration(wait_duration);


# Create an array to snyc the text and the picture
if (output_port_manager.port_count() == 0) then
   term.print_line( "Forgot to add an output port!" )
end;
output_port oport = output_port_manager.get_port( 1 );

array<int> index[2];
index[1] = 1;
index[2] = 2;
#index[3] = 3;

term.print_line("Start");

term.print_line(instr_code);
oport.send_code(instr_code);
instr_trial.present();

term.print_line(intro_code);
oport.send_code(intro_code);
intro_trial.present();

loop int i = 1 until i > number_of_trials begin
	index.shuffle();
	# The Initial Wait with Cross 
	term.print_line(wait_code);
	oport.send_code(wait_code);
	wait_trial.present();
	
	# Set up the actual Trial
	pic.set_part(1, arrows[index[1]]);
	pic.set_part(2, arrow_pictures[index[1]]);
	event1.set_event_code(arrows[index[1]].description());	
	if index[1] == 1 then 
		term.print_line(left_code);
		oport.send_code(left_code);
	elseif index[1] == 2 then
		term.print_line(right_code);
		oport.send_code(right_code);
	#elseif index[1] == 3 then
		#term.print_line(no_code);
		#oport.send_code(no_code);
	end;
	
	# Present the actual Trial
	main_trial.set_duration(main_duration);
	main_trial.present();	
	
	# Rest Period
	pic.set_part(1, arrows[3]);
	pic.set_part(2, arrow_pictures[3]);
	event1.set_event_code(arrows[3].description());	
	main_trial.set_duration(wait_main_duration);
	main_trial.present();
	i = i + 1
end;
term.print_line("End");