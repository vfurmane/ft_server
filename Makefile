# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vfurmane <vfurmane@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/03/27 20:13:53 by vfurmane          #+#    #+#              #
#    Updated: 2021/03/27 21:09:27 by vfurmane         ###   ########.fr        #
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
ifneq ($(shell docker ps -aq | wc -l),0)
			docker stop $(shell docker ps -aq -f 'label=image=ft_server')
			docker rm $(shell docker ps -aq -f 'label=image=ft_server')
endif

fclean:		clean
ifneq ($(shell docker images | grep $(NAME) | wc -l),0)
			docker rmi $(NAME)
endif

re:			fclean all

.PHONY:		all help clean fclean re
