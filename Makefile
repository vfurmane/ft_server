# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vfurmane <vfurmane@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/03/27 20:13:53 by vfurmane          #+#    #+#              #
#    Updated: 2021/03/28 18:07:11 by vfurmane         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME		= ft_server
PORTS		= $(addprefix -p , 80:80 443:443)
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

debug:
ifneq ($(shell docker ps -lq -f 'label=image=ft_server' -f "status=running" | wc -l),0)
			docker exec -it $(shell docker ps -lq -f 'label=image=ft_server' -f "status=running") bash
endif

clean:
ifneq ($(shell docker ps -aq -f 'label=image=ft_server' | wc -l),0)
			docker stop $(shell docker ps -aq -f 'label=image=ft_server')
			docker rm $(shell docker ps -aq -f 'label=image=ft_server')
endif

fclean:		clean
ifneq ($(shell docker images | grep $(NAME) | wc -l),0)
			docker rmi $(NAME)
endif

re:			fclean all

.PHONY:		all help build run debug clean fclean re
