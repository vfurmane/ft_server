# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vfurmane <vfurmane@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/03/27 20:13:53 by vfurmane          #+#    #+#              #
#    Updated: 2021/03/27 20:13:55 by vfurmane         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME		= ft_server
PORTS		= $(addprefix -p , 80:80)

all:		$(NAME)

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

.PHONY:		all clean fclean re
