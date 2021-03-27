# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vfurmane <vfurmane@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/03/27 20:13:53 by vfurmane          #+#    #+#              #
#    Updated: 2021/03/27 20:59:57 by vfurmane         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME		= ft_server
PORTS		= $(addprefix -p , 80:80)
HELP_MSG	= "Usage: make all|help|build|run|clean|fclean|re\n\n\
\tall:		Build the image and run it in a container\n\
\thelp:		Echo this message\n\
\tbuild:		Build the image\n\
\trun:		Run the image in a container\n\
\tclean:		Remove all $(NAME) containers\n\
\tfclean:		Remove all $(NAME) containers and remove the $(NAME) image\n\
\tre:		Re-build the image\n"

all:		$(NAME)

help:
			@echo $(HELP_MSG)

$(NAME):	build run

build:
			docker build -t $(NAME) .

run:
			docker run $(PORTS) $(NAME)

clean:
			docker rm $(shell docker ps -alq -f 'label=image=ft_server')

fclean:		clean
			docker rmi $(NAME)

re:			fclean all

.PHONY:		all help clean fclean re
